SET check_function_bodies = false;
INSERT INTO public.users (id, created_at, updated_at, display_name, avatar_url) VALUES ('a75fb0d3-fbd4-45c2-903f-cf845e0d3ed0', '2022-03-25 16:52:03.498476+00', '2022-03-25 16:52:03.498476+00', 'anoopbenzier@gmail.com', NULL);
INSERT INTO auth.accounts (id, created_at, updated_at, user_id, active, email, new_email, password_hash, default_role, is_anonymous, custom_register_data, otp_secret, mfa_enabled, ticket, ticket_expires_at) VALUES ('4a72340e-78ca-438a-857e-b9dea769e5c1', '2022-03-25 16:52:03.498476+00', '2022-03-25 16:52:03.498476+00', 'a75fb0d3-fbd4-45c2-903f-cf845e0d3ed0', true, 'anoopbenzier@gmail.com', NULL, '$2a$10$XT3atKFvQqvLAzP4hwG8d.3Wd9oHGCYdyuXUuof.CslaTnBBYgIri', 'user', false, NULL, NULL, false, 'd119dda0-a5a7-4fcb-9d5c-25b8fbfbaa31', '2022-03-25 17:52:03.362+00');
INSERT INTO auth.account_roles (id, created_at, account_id, role) VALUES ('64662172-5f95-454b-8ec9-2783101cbd65', '2022-03-25 16:52:03.498476+00', '4a72340e-78ca-438a-857e-b9dea769e5c1', 'user');
INSERT INTO auth.account_roles (id, created_at, account_id, role) VALUES ('95861c60-fc53-4eb6-a11e-ce1a879a46c1', '2022-03-25 16:52:03.498476+00', '4a72340e-78ca-438a-857e-b9dea769e5c1', 'me');
INSERT INTO auth.refresh_tokens (refresh_token, created_at, expires_at, account_id) VALUES ('e6665a66-ff7c-4638-be4f-7fb6521030d8', '2022-03-25 16:52:03.514503+00', '2022-04-24 16:52:03.51+00', '4a72340e-78ca-438a-857e-b9dea769e5c1');
INSERT INTO public.todos (id, title, description, created_by) VALUES ('cbf98008-36a6-4555-920c-8b0b71918364', 'Hello World', 'A to do description', 'a75fb0d3-fbd4-45c2-903f-cf845e0d3ed0');
