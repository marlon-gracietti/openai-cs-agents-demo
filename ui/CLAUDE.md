# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Customer Service Agents Demo built with Next.js frontend and Python backend, showcasing the OpenAI Agents SDK for airline customer service workflows. The UI visualizes agent orchestration and provides a chat interface.

## Architecture

- **Frontend**: Next.js 15 with React 19, TypeScript, and Tailwind CSS
- **Backend**: Python FastAPI with OpenAI Agents SDK (located in `../python-backend/`)
- **Communication**: Frontend proxies `/chat` requests to backend at `127.0.0.1:8000` in development
- **Components**: Modular React components for chat, agent panels, seat maps, and guardrails visualization

## Development Commands

### Frontend (from `ui/` directory)
- `npm run dev` - Starts both frontend (port 3000) and backend (port 8000) concurrently
- `npm run dev:next` - Start only Next.js frontend
- `npm run dev:server` - Start only Python backend
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run Next.js linting

### Backend Setup (from `../python-backend/`)
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python -m uvicorn api:app --reload --port 8000
```

## Key Components

- **Chat.tsx**: Main chat interface with seat map integration
- **agent-panel.tsx**: Displays agent orchestration flow
- **guardrails.tsx**: Shows guardrail checks (relevance, jailbreak detection)
- **seat-map.tsx**: Interactive airline seat selection
- **lib/types.ts**: Core TypeScript interfaces for messages, agents, events, and guardrails

## Configuration

- **next.config.mjs**: Proxies `/chat` to backend in development
- **tailwind.config.ts**: Uses shadcn/ui design system with CSS variables
- **tsconfig.json**: Path aliases with `@/*` pointing to root

## Environment Setup

Set `OPENAI_API_KEY` environment variable or create `.env` file in `../python-backend/`

## Special Features

- Real-time agent handoffs and tool execution visualization
- Interactive seat map with aircraft layout
- Guardrail violation detection and display
- Context-aware message routing between specialized agents (Triage, Seat Booking, Flight Status, Cancellation, FAQ)