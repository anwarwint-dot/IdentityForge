import pytest

from src.database import get_connection


def test_missing_database_password(monkeypatch):
    """Reject connections when credentials are missing."""

    monkeypatch.delenv("IDENTITYFORGE_DB_PASSWORD", raising=False)

    with pytest.raises(
        RuntimeError,
        match="IDENTITYFORGE_DB_PASSWORD is not configured"
    ):
        get_connection()
