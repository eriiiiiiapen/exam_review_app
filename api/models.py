from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column
from sqlalchemy import Integer, Text, Date, ForeignKey, BigInteger
from datetime import date

class Base(DeclarativeBase):
    pass

class Topic(Base):
    __tablename__ = "topics"
    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str]
    description: Mapped[str | None]
    correct_answer: Mapped[str | None]
    subject_id: Mapped[int] = mapped_column(BigInteger)

class StudyLog(Base):
    __tablename__ = "study_logs"
    id: Mapped[int] = mapped_column(primary_key=True)
    user_id: Mapped[int] = mapped_column(BigInteger)
    topic_id: Mapped[int] = mapped_column(ForeignKey("topics.id"), type_=BigInteger)
    understanding_level: Mapped[int] = mapped_column(Integer, default=0)
    study_on: Mapped[date | None] = mapped_column(Date)
    note: Mapped[str | None] = mapped_column(Text)