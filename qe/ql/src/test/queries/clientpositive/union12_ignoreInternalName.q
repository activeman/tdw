set hive.map.aggr = true;

-- union case: all subqueries are a map-reduce jobs, 3 way union, different inputs for all sub-queries, followed by filesink

drop table tmptable;
create table tmptable(key string, value int);

explain 
insert overwrite table tmptable
  select unionsrc.key, unionsrc.value FROM (select 'tst1' as key, count(1) as value from src s1
                                        UNION  ALL  
                                            select 'tst2', count(1) from src1 s2
                                        UNION ALL
                                            select 'tst3', count(1) from srcbucket s3) unionsrc;


insert overwrite table tmptable
  select unionsrc.key, unionsrc.value FROM (select 'tst1' as key, count(1) as value from src s1
                                        UNION  ALL  
                                            select 'tst2', count(1) from src1 s2
                                        UNION ALL
                                            select 'tst3', count(1) from srcbucket s3) unionsrc;

select * from tmptable x sort by x.key;

drop table tmptable;
