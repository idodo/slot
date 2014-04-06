统计当天的各平台有效金币产出量：
select sum(gold), ad_type_name from gold_earn_record where created_at > current_date() and status=0  group by ad_type_name;
