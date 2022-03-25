alter table "public"."todos" drop constraint "todos_created_by_fkey",
  add constraint "todos_id_fkey"
  foreign key ("id")
  references "public"."users"
  ("id") on update restrict on delete restrict;
