import os
import psycopg


def get_connection():
    """Connect to the IdentityForge PostgreSQL database."""

    password = os.environ.get("IDENTITYFORGE_DB_PASSWORD")

    if not password:
        raise RuntimeError(
            "IDENTITYFORGE_DB_PASSWORD is not configured."
        )

    return psycopg.connect(
        host="localhost",
        dbname="identityforge",
        user="postgres",
        password=password,
        connect_timeout=5,
    )
