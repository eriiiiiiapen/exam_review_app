from fastapi import FastAPI
from strawberry.fastapi import GraphQLRouter
from database import AsyncSessionLocal
from schema import schema 

async def get_context():
    async with AsyncSessionLocal() as session:
        return {"db": session}

app = FastAPI()
graphql_app = GraphQLRouter(schema, context_getter=get_context)
app.include_router(graphql_app, prefix="/graphql")
