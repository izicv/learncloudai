-- Sample data generated from lib/trainings.ts and lib/courses.ts.
-- Run after the migrations. Safe to re-run: it clears the sample rows first.

delete from public.courses where slug in ('ai-associate-foundations', 'prompt-engineering-essentials', 'building-ai-agents', 'mcp-and-tool-integration', 'ai-for-business-productivity', 'rag-and-knowledge-systems', 'live-ai-workshop-hands-on', 'evaluating-llm-applications', 'ai-security-and-safety', 'ai-coding-assistants', 'live-q-and-a-ai-careers', 'data-analysis-with-ai', 'multimodal-ai-basics', 'ai-workflow-automation');

insert into public.courses
  (slug, title, short_description, footer_text, level, kind, provider, prices, status)
values
  ('ai-associate-foundations', 'AI Associate: Foundations', 'Start here. Learn what AI is, how models work and how to use them well day to day.', '3 units · 18 lessons', 'Beginner', 'course', 'anthropic', '{}'::jsonb, 'published'),
  ('prompt-engineering-essentials', 'Prompt Engineering Essentials', 'Write clear prompts, use examples and get reliable structured output from language models.', '3 units · 14 lessons', 'Beginner', 'course', 'openai', '{}'::jsonb, 'published'),
  ('building-ai-agents', 'Building AI Agents', 'Design agent loops, give models tools and orchestrate several agents for real tasks.', '3 units · 22 lessons', 'Intermediate', 'course', 'anthropic', '{"USD":1900,"INR":99900}'::jsonb, 'published'),
  ('mcp-and-tool-integration', 'MCP and Tool Integration', 'Connect models to your systems with well-designed tools and Model Context Protocol servers.', '3 units · 12 lessons', 'Intermediate', 'course', 'anthropic', '{"USD":1500,"INR":79900}'::jsonb, 'published'),
  ('ai-for-business-productivity', 'AI for Business Productivity', 'Use AI assistants for writing, analysis, planning and everyday knowledge work.', '3 units · 16 lessons', 'Beginner', 'course', 'google', '{}'::jsonb, 'published'),
  ('rag-and-knowledge-systems', 'RAG and Knowledge Systems', 'Build retrieval-augmented systems: chunking, embeddings, search quality and evaluation.', '3 units · 20 lessons', 'Advanced', 'course', 'openai', '{"USD":2900,"INR":149900}'::jsonb, 'published'),
  ('live-ai-workshop-hands-on', 'Live Workshop: Hands-on AI Projects', 'Join a live session, build a small AI project with an instructor and ask questions.', 'Live · Sat 10:00 AM IST', 'Beginner', 'live', 'google', '{"USD":900,"INR":49900}'::jsonb, 'published'),
  ('evaluating-llm-applications', 'Evaluating LLM Applications', 'Measure quality, catch regressions and build test sets for production AI features.', '3 units · 10 lessons', 'Advanced', 'course', 'openai', '{"USD":2400,"INR":119900}'::jsonb, 'published'),
  ('ai-security-and-safety', 'AI Security and Safety', 'Understand prompt injection, data leakage and guardrails when shipping AI products.', '3 units · 11 lessons', 'Advanced', 'course', 'anthropic', '{"USD":2400,"INR":119900}'::jsonb, 'published'),
  ('ai-coding-assistants', 'Working with AI Coding Assistants', 'Plan, review and iterate with coding assistants, and set them up for your team''s workflow.', '3 units · 15 lessons', 'Intermediate', 'course', 'anthropic', '{"USD":1700,"INR":89900}'::jsonb, 'published'),
  ('live-q-and-a-ai-careers', 'Live Q&A: Careers in AI', 'Open session on skills, roles and learning paths for people moving into AI work.', 'Live · Sun 6:00 PM IST', 'Beginner', 'live', 'openai', '{}'::jsonb, 'published'),
  ('data-analysis-with-ai', 'Data Analysis with AI', 'Clean data, explore it and produce charts and summaries using AI tools safely.', '3 units · 13 lessons', 'Intermediate', 'course', 'google', '{"USD":1600,"INR":84900}'::jsonb, 'published'),
  ('multimodal-ai-basics', 'Multimodal AI Basics', 'Work with images, audio and documents alongside text in modern AI models.', '3 units · 9 lessons', 'Beginner', 'course', 'google', '{}'::jsonb, 'published'),
  ('ai-workflow-automation', 'AI Workflow Automation', 'Automate repeatable work by chaining prompts, tools and checks into reliable workflows.', '3 units · 12 lessons', 'Intermediate', 'course', 'openai', '{"USD":1400,"INR":74900}'::jsonb, 'published');

-- Units (3 per course; live trainings have none)
insert into public.units (course_id, position, title, summary)
select c.id, v.position, v.title, v.summary
from (values
  ('ai-associate-foundations', 1, 'Unit 1: Basics', 'The core ideas you need before anything else.'),
  ('ai-associate-foundations', 2, 'Unit 2: Intermediate', 'Apply the basics to realistic tasks.'),
  ('ai-associate-foundations', 3, 'Unit 3: Advanced', 'Go deeper and make it reliable.'),
  ('prompt-engineering-essentials', 1, 'Unit 1: Basics', 'The core ideas you need before anything else.'),
  ('prompt-engineering-essentials', 2, 'Unit 2: Intermediate', 'Apply the basics to realistic tasks.'),
  ('prompt-engineering-essentials', 3, 'Unit 3: Advanced', 'Go deeper and make it reliable.'),
  ('building-ai-agents', 1, 'Unit 1: Basics', 'The core ideas you need before anything else.'),
  ('building-ai-agents', 2, 'Unit 2: Intermediate', 'Apply the basics to realistic tasks.'),
  ('building-ai-agents', 3, 'Unit 3: Advanced', 'Go deeper and make it reliable.'),
  ('mcp-and-tool-integration', 1, 'Unit 1: Basics', 'The core ideas you need before anything else.'),
  ('mcp-and-tool-integration', 2, 'Unit 2: Intermediate', 'Apply the basics to realistic tasks.'),
  ('mcp-and-tool-integration', 3, 'Unit 3: Advanced', 'Go deeper and make it reliable.'),
  ('ai-for-business-productivity', 1, 'Unit 1: Basics', 'The core ideas you need before anything else.'),
  ('ai-for-business-productivity', 2, 'Unit 2: Intermediate', 'Apply the basics to realistic tasks.'),
  ('ai-for-business-productivity', 3, 'Unit 3: Advanced', 'Go deeper and make it reliable.'),
  ('rag-and-knowledge-systems', 1, 'Unit 1: Basics', 'The core ideas you need before anything else.'),
  ('rag-and-knowledge-systems', 2, 'Unit 2: Intermediate', 'Apply the basics to realistic tasks.'),
  ('rag-and-knowledge-systems', 3, 'Unit 3: Advanced', 'Go deeper and make it reliable.'),
  ('evaluating-llm-applications', 1, 'Unit 1: Basics', 'The core ideas you need before anything else.'),
  ('evaluating-llm-applications', 2, 'Unit 2: Intermediate', 'Apply the basics to realistic tasks.'),
  ('evaluating-llm-applications', 3, 'Unit 3: Advanced', 'Go deeper and make it reliable.'),
  ('ai-security-and-safety', 1, 'Unit 1: Basics', 'The core ideas you need before anything else.'),
  ('ai-security-and-safety', 2, 'Unit 2: Intermediate', 'Apply the basics to realistic tasks.'),
  ('ai-security-and-safety', 3, 'Unit 3: Advanced', 'Go deeper and make it reliable.'),
  ('ai-coding-assistants', 1, 'Unit 1: Basics', 'The core ideas you need before anything else.'),
  ('ai-coding-assistants', 2, 'Unit 2: Intermediate', 'Apply the basics to realistic tasks.'),
  ('ai-coding-assistants', 3, 'Unit 3: Advanced', 'Go deeper and make it reliable.'),
  ('data-analysis-with-ai', 1, 'Unit 1: Basics', 'The core ideas you need before anything else.'),
  ('data-analysis-with-ai', 2, 'Unit 2: Intermediate', 'Apply the basics to realistic tasks.'),
  ('data-analysis-with-ai', 3, 'Unit 3: Advanced', 'Go deeper and make it reliable.'),
  ('multimodal-ai-basics', 1, 'Unit 1: Basics', 'The core ideas you need before anything else.'),
  ('multimodal-ai-basics', 2, 'Unit 2: Intermediate', 'Apply the basics to realistic tasks.'),
  ('multimodal-ai-basics', 3, 'Unit 3: Advanced', 'Go deeper and make it reliable.'),
  ('ai-workflow-automation', 1, 'Unit 1: Basics', 'The core ideas you need before anything else.'),
  ('ai-workflow-automation', 2, 'Unit 2: Intermediate', 'Apply the basics to realistic tasks.'),
  ('ai-workflow-automation', 3, 'Unit 3: Advanced', 'Go deeper and make it reliable.')
) as v(slug, position, title, summary)
join public.courses c on c.slug = v.slug;

-- Lessons
insert into public.lessons (unit_id, position, title, content, video_url, duration_minutes)
select u.id, v.lesson_position, v.title, v.content, nullif(v.video_url, ''), v.duration_minutes
from (values
  ('ai-associate-foundations', 1, 1, 'Welcome and goals', 'Welcome and goals for “AI Associate: Foundations”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 9),
  ('ai-associate-foundations', 1, 2, 'Key concepts', 'Key concepts for “AI Associate: Foundations”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 10),
  ('ai-associate-foundations', 1, 3, 'Your first hands-on example', 'Your first hands-on example for “AI Associate: Foundations”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 11),
  ('ai-associate-foundations', 2, 1, 'Working patterns', 'Working patterns for “AI Associate: Foundations”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 12),
  ('ai-associate-foundations', 2, 2, 'Common mistakes', 'Common mistakes for “AI Associate: Foundations”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 13),
  ('ai-associate-foundations', 2, 3, 'A guided project', 'A guided project for “AI Associate: Foundations”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 14),
  ('ai-associate-foundations', 3, 1, 'Design trade-offs', 'Design trade-offs for “AI Associate: Foundations”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 15),
  ('ai-associate-foundations', 3, 2, 'Testing and evaluation', 'Testing and evaluation for “AI Associate: Foundations”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 16),
  ('ai-associate-foundations', 3, 3, 'Putting it together', 'Putting it together for “AI Associate: Foundations”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 17),
  ('prompt-engineering-essentials', 1, 1, 'Welcome and goals', 'Welcome and goals for “Prompt Engineering Essentials”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 9),
  ('prompt-engineering-essentials', 1, 2, 'Key concepts', 'Key concepts for “Prompt Engineering Essentials”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 10),
  ('prompt-engineering-essentials', 1, 3, 'Your first hands-on example', 'Your first hands-on example for “Prompt Engineering Essentials”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 11),
  ('prompt-engineering-essentials', 2, 1, 'Working patterns', 'Working patterns for “Prompt Engineering Essentials”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 12),
  ('prompt-engineering-essentials', 2, 2, 'Common mistakes', 'Common mistakes for “Prompt Engineering Essentials”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 13),
  ('prompt-engineering-essentials', 2, 3, 'A guided project', 'A guided project for “Prompt Engineering Essentials”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 14),
  ('prompt-engineering-essentials', 3, 1, 'Design trade-offs', 'Design trade-offs for “Prompt Engineering Essentials”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 15),
  ('prompt-engineering-essentials', 3, 2, 'Testing and evaluation', 'Testing and evaluation for “Prompt Engineering Essentials”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 16),
  ('prompt-engineering-essentials', 3, 3, 'Putting it together', 'Putting it together for “Prompt Engineering Essentials”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 17),
  ('building-ai-agents', 1, 1, 'Welcome and goals', 'Welcome and goals for “Building AI Agents”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 9),
  ('building-ai-agents', 1, 2, 'Key concepts', 'Key concepts for “Building AI Agents”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 10),
  ('building-ai-agents', 1, 3, 'Your first hands-on example', 'Your first hands-on example for “Building AI Agents”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 11),
  ('building-ai-agents', 2, 1, 'Working patterns', 'Working patterns for “Building AI Agents”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 12),
  ('building-ai-agents', 2, 2, 'Common mistakes', 'Common mistakes for “Building AI Agents”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 13),
  ('building-ai-agents', 2, 3, 'A guided project', 'A guided project for “Building AI Agents”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 14),
  ('building-ai-agents', 3, 1, 'Design trade-offs', 'Design trade-offs for “Building AI Agents”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 15),
  ('building-ai-agents', 3, 2, 'Testing and evaluation', 'Testing and evaluation for “Building AI Agents”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 16),
  ('building-ai-agents', 3, 3, 'Putting it together', 'Putting it together for “Building AI Agents”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 17),
  ('mcp-and-tool-integration', 1, 1, 'Welcome and goals', 'Welcome and goals for “MCP and Tool Integration”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 9),
  ('mcp-and-tool-integration', 1, 2, 'Key concepts', 'Key concepts for “MCP and Tool Integration”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 10),
  ('mcp-and-tool-integration', 1, 3, 'Your first hands-on example', 'Your first hands-on example for “MCP and Tool Integration”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 11),
  ('mcp-and-tool-integration', 2, 1, 'Working patterns', 'Working patterns for “MCP and Tool Integration”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 12),
  ('mcp-and-tool-integration', 2, 2, 'Common mistakes', 'Common mistakes for “MCP and Tool Integration”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 13),
  ('mcp-and-tool-integration', 2, 3, 'A guided project', 'A guided project for “MCP and Tool Integration”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 14),
  ('mcp-and-tool-integration', 3, 1, 'Design trade-offs', 'Design trade-offs for “MCP and Tool Integration”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 15),
  ('mcp-and-tool-integration', 3, 2, 'Testing and evaluation', 'Testing and evaluation for “MCP and Tool Integration”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 16),
  ('mcp-and-tool-integration', 3, 3, 'Putting it together', 'Putting it together for “MCP and Tool Integration”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 17),
  ('ai-for-business-productivity', 1, 1, 'Welcome and goals', 'Welcome and goals for “AI for Business Productivity”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 9),
  ('ai-for-business-productivity', 1, 2, 'Key concepts', 'Key concepts for “AI for Business Productivity”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 10),
  ('ai-for-business-productivity', 1, 3, 'Your first hands-on example', 'Your first hands-on example for “AI for Business Productivity”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 11),
  ('ai-for-business-productivity', 2, 1, 'Working patterns', 'Working patterns for “AI for Business Productivity”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 12),
  ('ai-for-business-productivity', 2, 2, 'Common mistakes', 'Common mistakes for “AI for Business Productivity”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 13),
  ('ai-for-business-productivity', 2, 3, 'A guided project', 'A guided project for “AI for Business Productivity”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 14),
  ('ai-for-business-productivity', 3, 1, 'Design trade-offs', 'Design trade-offs for “AI for Business Productivity”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 15),
  ('ai-for-business-productivity', 3, 2, 'Testing and evaluation', 'Testing and evaluation for “AI for Business Productivity”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 16),
  ('ai-for-business-productivity', 3, 3, 'Putting it together', 'Putting it together for “AI for Business Productivity”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 17),
  ('rag-and-knowledge-systems', 1, 1, 'Welcome and goals', 'Welcome and goals for “RAG and Knowledge Systems”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 9),
  ('rag-and-knowledge-systems', 1, 2, 'Key concepts', 'Key concepts for “RAG and Knowledge Systems”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 10),
  ('rag-and-knowledge-systems', 1, 3, 'Your first hands-on example', 'Your first hands-on example for “RAG and Knowledge Systems”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 11),
  ('rag-and-knowledge-systems', 2, 1, 'Working patterns', 'Working patterns for “RAG and Knowledge Systems”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 12),
  ('rag-and-knowledge-systems', 2, 2, 'Common mistakes', 'Common mistakes for “RAG and Knowledge Systems”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 13),
  ('rag-and-knowledge-systems', 2, 3, 'A guided project', 'A guided project for “RAG and Knowledge Systems”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 14),
  ('rag-and-knowledge-systems', 3, 1, 'Design trade-offs', 'Design trade-offs for “RAG and Knowledge Systems”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 15),
  ('rag-and-knowledge-systems', 3, 2, 'Testing and evaluation', 'Testing and evaluation for “RAG and Knowledge Systems”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 16),
  ('rag-and-knowledge-systems', 3, 3, 'Putting it together', 'Putting it together for “RAG and Knowledge Systems”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 17),
  ('evaluating-llm-applications', 1, 1, 'Welcome and goals', 'Welcome and goals for “Evaluating LLM Applications”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 9),
  ('evaluating-llm-applications', 1, 2, 'Key concepts', 'Key concepts for “Evaluating LLM Applications”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 10),
  ('evaluating-llm-applications', 1, 3, 'Your first hands-on example', 'Your first hands-on example for “Evaluating LLM Applications”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 11),
  ('evaluating-llm-applications', 2, 1, 'Working patterns', 'Working patterns for “Evaluating LLM Applications”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 12),
  ('evaluating-llm-applications', 2, 2, 'Common mistakes', 'Common mistakes for “Evaluating LLM Applications”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 13),
  ('evaluating-llm-applications', 2, 3, 'A guided project', 'A guided project for “Evaluating LLM Applications”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 14),
  ('evaluating-llm-applications', 3, 1, 'Design trade-offs', 'Design trade-offs for “Evaluating LLM Applications”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 15),
  ('evaluating-llm-applications', 3, 2, 'Testing and evaluation', 'Testing and evaluation for “Evaluating LLM Applications”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 16),
  ('evaluating-llm-applications', 3, 3, 'Putting it together', 'Putting it together for “Evaluating LLM Applications”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 17),
  ('ai-security-and-safety', 1, 1, 'Welcome and goals', 'Welcome and goals for “AI Security and Safety”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 9),
  ('ai-security-and-safety', 1, 2, 'Key concepts', 'Key concepts for “AI Security and Safety”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 10),
  ('ai-security-and-safety', 1, 3, 'Your first hands-on example', 'Your first hands-on example for “AI Security and Safety”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 11),
  ('ai-security-and-safety', 2, 1, 'Working patterns', 'Working patterns for “AI Security and Safety”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 12),
  ('ai-security-and-safety', 2, 2, 'Common mistakes', 'Common mistakes for “AI Security and Safety”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 13),
  ('ai-security-and-safety', 2, 3, 'A guided project', 'A guided project for “AI Security and Safety”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 14),
  ('ai-security-and-safety', 3, 1, 'Design trade-offs', 'Design trade-offs for “AI Security and Safety”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 15),
  ('ai-security-and-safety', 3, 2, 'Testing and evaluation', 'Testing and evaluation for “AI Security and Safety”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 16),
  ('ai-security-and-safety', 3, 3, 'Putting it together', 'Putting it together for “AI Security and Safety”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 17),
  ('ai-coding-assistants', 1, 1, 'Welcome and goals', 'Welcome and goals for “Working with AI Coding Assistants”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 9),
  ('ai-coding-assistants', 1, 2, 'Key concepts', 'Key concepts for “Working with AI Coding Assistants”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 10),
  ('ai-coding-assistants', 1, 3, 'Your first hands-on example', 'Your first hands-on example for “Working with AI Coding Assistants”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 11),
  ('ai-coding-assistants', 2, 1, 'Working patterns', 'Working patterns for “Working with AI Coding Assistants”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 12),
  ('ai-coding-assistants', 2, 2, 'Common mistakes', 'Common mistakes for “Working with AI Coding Assistants”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 13),
  ('ai-coding-assistants', 2, 3, 'A guided project', 'A guided project for “Working with AI Coding Assistants”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 14),
  ('ai-coding-assistants', 3, 1, 'Design trade-offs', 'Design trade-offs for “Working with AI Coding Assistants”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 15),
  ('ai-coding-assistants', 3, 2, 'Testing and evaluation', 'Testing and evaluation for “Working with AI Coding Assistants”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 16),
  ('ai-coding-assistants', 3, 3, 'Putting it together', 'Putting it together for “Working with AI Coding Assistants”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 17),
  ('data-analysis-with-ai', 1, 1, 'Welcome and goals', 'Welcome and goals for “Data Analysis with AI”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 9),
  ('data-analysis-with-ai', 1, 2, 'Key concepts', 'Key concepts for “Data Analysis with AI”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 10),
  ('data-analysis-with-ai', 1, 3, 'Your first hands-on example', 'Your first hands-on example for “Data Analysis with AI”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 11),
  ('data-analysis-with-ai', 2, 1, 'Working patterns', 'Working patterns for “Data Analysis with AI”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 12),
  ('data-analysis-with-ai', 2, 2, 'Common mistakes', 'Common mistakes for “Data Analysis with AI”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 13),
  ('data-analysis-with-ai', 2, 3, 'A guided project', 'A guided project for “Data Analysis with AI”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 14),
  ('data-analysis-with-ai', 3, 1, 'Design trade-offs', 'Design trade-offs for “Data Analysis with AI”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 15),
  ('data-analysis-with-ai', 3, 2, 'Testing and evaluation', 'Testing and evaluation for “Data Analysis with AI”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 16),
  ('data-analysis-with-ai', 3, 3, 'Putting it together', 'Putting it together for “Data Analysis with AI”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 17),
  ('multimodal-ai-basics', 1, 1, 'Welcome and goals', 'Welcome and goals for “Multimodal AI Basics”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 9),
  ('multimodal-ai-basics', 1, 2, 'Key concepts', 'Key concepts for “Multimodal AI Basics”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 10),
  ('multimodal-ai-basics', 1, 3, 'Your first hands-on example', 'Your first hands-on example for “Multimodal AI Basics”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 11),
  ('multimodal-ai-basics', 2, 1, 'Working patterns', 'Working patterns for “Multimodal AI Basics”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 12),
  ('multimodal-ai-basics', 2, 2, 'Common mistakes', 'Common mistakes for “Multimodal AI Basics”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 13),
  ('multimodal-ai-basics', 2, 3, 'A guided project', 'A guided project for “Multimodal AI Basics”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 14),
  ('multimodal-ai-basics', 3, 1, 'Design trade-offs', 'Design trade-offs for “Multimodal AI Basics”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 15),
  ('multimodal-ai-basics', 3, 2, 'Testing and evaluation', 'Testing and evaluation for “Multimodal AI Basics”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 16),
  ('multimodal-ai-basics', 3, 3, 'Putting it together', 'Putting it together for “Multimodal AI Basics”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 17),
  ('ai-workflow-automation', 1, 1, 'Welcome and goals', 'Welcome and goals for “AI Workflow Automation”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 9),
  ('ai-workflow-automation', 1, 2, 'Key concepts', 'Key concepts for “AI Workflow Automation”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 10),
  ('ai-workflow-automation', 1, 3, 'Your first hands-on example', 'Your first hands-on example for “AI Workflow Automation”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 11),
  ('ai-workflow-automation', 2, 1, 'Working patterns', 'Working patterns for “AI Workflow Automation”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 12),
  ('ai-workflow-automation', 2, 2, 'Common mistakes', 'Common mistakes for “AI Workflow Automation”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 13),
  ('ai-workflow-automation', 2, 3, 'A guided project', 'A guided project for “AI Workflow Automation”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 14),
  ('ai-workflow-automation', 3, 1, 'Design trade-offs', 'Design trade-offs for “AI Workflow Automation”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 15),
  ('ai-workflow-automation', 3, 2, 'Testing and evaluation', 'Testing and evaluation for “AI Workflow Automation”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 16),
  ('ai-workflow-automation', 3, 3, 'Putting it together', 'Putting it together for “AI Workflow Automation”.

This is sample text. The admin will write the real lesson here.

Each lesson has a video above and text below.', 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 17)
) as v(slug, unit_position, lesson_position, title, content, video_url, duration_minutes)
join public.courses c on c.slug = v.slug
join public.units u on u.course_id = c.id and u.position = v.unit_position;

-- Announcement shown on the home page
delete from public.announcements where title = 'Live Workshop: Hands-on AI Projects';
insert into public.announcements (title, body, link_url, active, sort_order)
values (
  'Live Workshop: Hands-on AI Projects',
  'Build a small AI project with an instructor. Saturday 10:00 AM IST',
  '/courses/live-ai-workshop-hands-on', true, 1
);
