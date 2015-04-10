Refernece a table : References ? Table ? Oracle PL/SQL Tutorial
Oracle PL/SQL TutorialTableReferences


SQL> set echo on
SQL>

SQL> create table p ( x int primary key );

Table created.

SQL>
SQL> create table c ( y references p );

Table created.

SQL>
SQL>
SQL> insert into p values ( 1 );

1 row created.

SQL>
SQL>
SQL> insert into p values ( 2 );

1 row created.

SQL>
SQL>
SQL> column columns format a30 word_wrapped
SQL> column tablename format a15 word_wrapped
SQL> column constraint_name format a15 word_wrapped
SQL>
SQL> select table_name, constraint_name,
  2         cname1 || nvl2(cname2,','||cname2,null) ||
  3         nvl2(cname3,','||cname3,null) || nvl2(cname4,','||cname4,null) ||
  4         nvl2(cname5,','||cname5,null) || nvl2(cname6,','||cname6,null) ||
  5         nvl2(cname7,','||cname7,null) || nvl2(cname8,','||cname8,null)
  6              columns
  7    from ( select b.table_name,
  8                  b.constraint_name,
  9                  max(decode( position, 1, column_name, null )) cname1,
 10                  max(decode( position, 2, column_name, null )) cname2,
 11                  max(decode( position, 3, column_name, null )) cname3,
 12                  max(decode( position, 4, column_name, null )) cname4,
 13                  max(decode( position, 5, column_name, null )) cname5,
 14                  max(decode( position, 6, column_name, null )) cname6,
 15                  max(decode( position, 7, column_name, null )) cname7,
 16                  max(decode( position, 8, column_name, null )) cname8,
 17                  count(*) col_cnt
 18             from (select substr(table_name,1,30) table_name,
 19                          substr(constraint_name,1,30) constraint_name,
 20                          substr(column_name,1,30) column_name,
 21                          position
 22                     from user_cons_columns ) a,
 23                  user_constraints b
 24            where a.constraint_name = b.constraint_name
 25              and b.constraint_type = 'R'
 26            group by b.table_name, b.constraint_name
 27         ) cons
 28   where col_cnt > ALL
 29           ( select count(*)
 30               from user_ind_columns i
 31              where i.table_name = cons.table_name
 32                and i.column_name in (cname1, cname2, cname3, cname4,
 33                                      cname5, cname6, cname7, cname8 )
 34                and i.column_position <= cons.col_cnt
 35              group by i.index_name
 36           )
 37  /

TABLE_NAME                     CONSTRAINT_NAME COLUMNS
------------------------------ --------------- ------------------------------
C                              SYS_C009529     Y

SQL>
SQL>
SQL> drop table c;

Table dropped.

SQL>
SQL> drop table p;

Table dropped.

SQL>
SQL>
SQL>
SQL>
SQL>
