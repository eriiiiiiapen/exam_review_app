from fastapi import FastAPI
from strawberry.fastapi import GraphQLRouter
from database import AsyncSessionLocal
from schema import schema 
from pydantic import BaseModel
from services.recall import record_result

async def get_context():
    async with AsyncSessionLocal() as session:
        return {"db": session}

app = FastAPI()
graphql_app = GraphQLRouter(schema, context_getter=get_context)
app.include_router(graphql_app, prefix="/graphql")

class RecallResultInput(BaseModel):
    topic_id: int
    is_correct: bool

@app.post("/recall/results")
async def post_recall_result(data: RecallResultInput):
    async with AsyncSessionLocal() as db:
        user_id = 1
        log = await record_result(user_id, data.topic_id, data.is_correct, db)
        
        return {
            "status": "success",
            "topic_id": log.topic_id,
            "new_level": log.understanding_level
        }