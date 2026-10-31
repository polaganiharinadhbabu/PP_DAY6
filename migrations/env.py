from dotenv import load_dotenv
import os

from app.database import Base
from app import models

load_dotenv()

config.set_main_option(
    "sqlalchemy.url",
    os.environ["DATABASE_URL"].replace("%", "%%"),
)

target_metadata = Base.metadata
