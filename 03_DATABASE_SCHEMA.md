{\rtf1\ansi\ansicpg1254\cocoartf2868
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # KAMULOG \'97 DATABASE SCHEMA\
\
## STRATEJ\uc0\u304 \
Remote (PostgreSQL/Supabase) ve Local (Drift/SQLite) senkronize \'e7al\uc0\u305 \u351 acak.\
\
---\
\
## 1. USERS TABLE\
```sql\
CREATE TABLE users (\
    id UUID PRIMARY KEY,\
    phone VARCHAR(15) UNIQUE NOT NULL,\
    full_name VARCHAR(100),\
    employment_type ENUM('memur', 'isci', 'sozlesmeli') NOT NULL, -- UI rengini ve ak\uc0\u305 \u351 \u305  belirler\
    ministry_code INT, -- Kurum kodu\
    title VARCHAR(50), -- \'dcnvan (Hem\uc0\u351 ire, VHK\u304  vb.)\
    created_at TIMESTAMP DEFAULT NOW()\
);}