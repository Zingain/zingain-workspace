alter table "public"."todos" drop constraint "todos_id_fkey",
  add constraint "todos_created_by_fkey"
  foreign key ("created_by")
  references "public"."users"
  ("id") on update restrict on delete restrict;
