from fastapi import FastAPI, Form
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from fastapi.requests import Request
import sqlite3
import os
import logging
import uvicorn

app = FastAPI()
templates = Jinja2Templates(directory="templates")

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def get_db():
    conn = sqlite3.connect("hazards.db")
    conn.execute("""
        CREATE TABLE IF NOT EXISTS hazards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT,
            severity TEXT,
            location TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    """)
    return conn

@app.get("/", response_class=HTMLResponse)
def home(request: Request):
    logger.info("Fetching hazards from database")
    conn = get_db()
    cur = conn.cursor()
    cur.execute("SELECT type, severity, location, created_at FROM hazards ORDER BY created_at DESC")
    hazards = cur.fetchall()
    cur.close()
    conn.close()
    logger.info(f"Retrieved {len(hazards)} hazards")
    return templates.TemplateResponse("index.html", {"request": request, "hazards": hazards})

@app.post("/hazards")
def add_hazard(
    hazard_type: str = Form(...),
    severity: str = Form(...),
    location: str = Form(...)
):
    logger.info(f"Adding hazard: type={hazard_type}, severity={severity}, location={location}")
    conn = get_db()
    cur = conn.cursor()
    cur.execute(
        "INSERT INTO hazards (type, severity, location) VALUES (?, ?, ?)",
        (hazard_type, severity, location)
    )
    conn.commit()
    cur.close()
    conn.close()
    logger.info("Hazard added successfully")
    return RedirectResponse(url="/", status_code=303)

@app.get("/health")
def health():
    return {"status": "healthy"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
