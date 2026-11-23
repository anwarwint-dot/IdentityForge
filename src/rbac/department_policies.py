from src.database import get_connection


def create_department_entitlements():
    """Create department-to-access-group policy mappings."""

    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                CREATE TABLE IF NOT EXISTS department_entitlements (
                    department_entitlement_id SERIAL PRIMARY KEY,
                    department_id INTEGER NOT NULL
                        REFERENCES departments(department_id),
                    group_id INTEGER NOT NULL
                        REFERENCES access_groups(group_id),
                    created_at TIMESTAMPTZ NOT NULL
                        DEFAULT CURRENT_TIMESTAMP,
                    UNIQUE (department_id, group_id)
                )
            """)

    print("Department entitlement policy table ready.")


if __name__ == "__main__":
    create_department_entitlements()
