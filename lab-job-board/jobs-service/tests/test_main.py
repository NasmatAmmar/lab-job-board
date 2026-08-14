import os
import uuid

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

# Force app startup to avoid using PostgreSQL in tests.
os.environ["DATABASE_URL"] = "sqlite+pysqlite:///:memory:"

from app import models  # noqa: E402
from app.database import Base, get_db  # noqa: E402
from app.main import app  # noqa: E402

TEST_DATABASE_URL = "sqlite+pysqlite:///:memory:"
engine = create_engine(
    TEST_DATABASE_URL,
    connect_args={"check_same_thread": False},
    poolclass=StaticPool,
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base.metadata.drop_all(bind=engine)
Base.metadata.create_all(bind=engine)


def override_get_db():
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()


app.dependency_overrides[get_db] = override_get_db
client = TestClient(app)


@pytest.fixture(autouse=True)
def clean_jobs_table():
    db = TestingSessionLocal()
    db.query(models.Job).delete()
    db.commit()
    db.close()


def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"


def test_create_job_valid_returns_201():
    payload = {
        "title": "Platform Engineer",
        "description": "Maintain CI/CD pipelines and production infrastructure.",
        "company": "Lab Inc",
        "location": "Remote",
    }

    response = client.post("/jobs", json=payload)

    assert response.status_code == 201
    body = response.json()
    assert body["id"]
    assert body["title"] == payload["title"]


def test_create_job_missing_fields_returns_422():
    response = client.post("/jobs", json={"title": "Only title"})
    assert response.status_code == 422


def test_get_non_existent_job_returns_404():
    missing_id = str(uuid.uuid4())
    response = client.get(f"/jobs/{missing_id}")
    assert response.status_code == 404
