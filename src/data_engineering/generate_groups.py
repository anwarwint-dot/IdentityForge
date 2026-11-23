from src.database import get_connection

TARGET_GROUPS = 300

SYSTEMS = [
    "Active Directory",
    "Entra ID",
    "Okta",
]


def generate_access_groups():
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT COUNT(*) FROM access_groups")
            existing = cur.fetchone()[0]

            if existing >= TARGET_GROUPS:
                print(f"Already have {existing} access groups.")
                return

            created = 0

            for number in range(1, TARGET_GROUPS + 1):
                group_name = f"GG-Enterprise-{number:04d}"
                system_name = SYSTEMS[(number - 1) % len(SYSTEMS)]

                cur.execute(
                    """
                    INSERT INTO access_groups (
                        group_name,
                        group_description,
                        system_name,
                        is_privileged
                    )
                    VALUES (%s, %s, %s, %s)
                    ON CONFLICT (group_name) DO NOTHING
                    """,
                    (
                        group_name,
                        f"Synthetic enterprise access group {number}",
                        system_name,
                        False,
                    ),
                )

                created += cur.rowcount

                cur.execute("SELECT COUNT(*) FROM access_groups")
                if cur.fetchone()[0] >= TARGET_GROUPS:
                    break

    print(f"Created {created} access groups.")
    print("Access group generation completed.")


if __name__ == "__main__":
    generate_access_groups()
