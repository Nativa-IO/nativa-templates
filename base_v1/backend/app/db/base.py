from sqlalchemy.orm import DeclarativeBase


class Base(DeclarativeBase):
    pass


# Import all models here so Alembic can detect them.
# This file is the single source of truth for metadata.
def import_all_models() -> None:
    pass
