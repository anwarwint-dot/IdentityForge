import random
from datetime import date

from faker import Faker
from src.database import get_connection

fake = Faker("en_US")
Faker.seed(42)
random.seed(42)

TARGET_EMPLOYEES = 5000


def generate_employees():
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT department_id FROM departments")
            departments = [row[0] for row in cur.fetchall()]

            cur.execute("SELECT role_id FROM job_roles")
            roles = [row[0] for row in cur.fetchall()]

            if not departments or not roles:
                raise RuntimeError(
                    "Departments and job roles must exist first."
                )

            cur.execute("SELECT COUNT(*) FROM employees")
            existing_count = cur.fetchone()[0]

            if existing_count >= TARGET_EMPLOYEES:
                print(f"Already have {existing_count} employees.")
                return

            cur.execute("SELECT COALESCE(MAX(employee_id), 0) FROM employees")
            next_number = cur.fetchone()[0] + 1

            to_create = TARGET_EMPLOYEES - existing_count

            for i in range(to_create):
                employee_number = f"EMP{next_number + i:06d}"
                first_name = fake.first_name()
                last_name = fake.last_name()
                email = (
                    f"{employee_number.lower()}@identityforge.example"
                )

                cur.execute(
                    """
                    INSERT INTO employees (
                        employee_number,
                        first_name,
                        last_name,
                        email,
                        department_id,
                        role_id,
                        employment_status,
                        hire_date
                    )
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                    """,
                    (
                        employee_number,
                        first_name,
                        last_name,
                        email,
                        random.choice(departments),
                        random.choice(roles),
                        random.choices(
                            ["Active", "Onboarding", "Leave"],
                            weights=[90, 5, 5]
                        )[0],
                        fake.date_between(
                            start_date=date(2018, 1, 1),
                            end_date=date.today()
                        ),
                    ),
                )

            print(f"Created {to_create} synthetic employees.")

    print("Employee generation completed successfully.")


if __name__ == "__main__":
    generate_employees()
