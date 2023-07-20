-- Demographic preferences(examples)
-- 1a Who prefers energy drink more? (male/female/non-binary?)
select gender,count(f.respondent_id) Total_respondents from 
fact_survey_responses f 
join dim_repondents r 
on r.Respondent_ID=f.Respondent_ID
group by gender 
order by Total_respondents desc;
----------------------------------------------------------------------------------------------------------------------------------
-- 1b  Which age group prefers energy drinks more?
select age,count(f.respondent_id) Total_peers from
fact_survey_responses f join dim_repondents d
on f.respondent_id = d.respondent_id
group by age
order by Total_peers asc;
----------------------------------------------------------------------------------------------------------------------------------
-- 1c Which type of marketing reaches the most Youth (15-30)?;
select Marketing_channels,count(f.respondent_id) Total_peers from
fact_survey_responses f join dim_repondents d
on f.respondent_id = d.respondent_id where age in ('15-18', '19-30')
group by Marketing_channels 
order by Total_peers desc;
----------------------------------------------------------------------------------------------------------------------------------
-- Consumer Preferences:
-- 2a What are the preferred ingredients of energy drinks among respondents?
select Ingredients_expected , count(Respondent_ID) from fact_survey_responses 
group by Ingredients_expected order by count(Respondent_ID) desc;
----------------------------------------------------------------------------------------------------------------------------------
-- 2b What packaging preferences do respondents have for energy drinks?
select count(Respondent_ID), Packaging_preference from fact_survey_responses 
group by Packaging_preference order by count(Respondent_ID) asc;
----------------------------------------------------------------------------------------------------------------------------------
-- Competition Analysis
-- 3a Who are the current market leaders?
select count(Respondent_ID), Current_brands from fact_survey_responses 
group by Current_brands order by count(Respondent_ID) desc;
----------------------------------------------------------------------------------------------------------------------------------
-- 3b What are the primary reasons consumers prefer those brands over ours?
select count(Respondent_ID), Reasons_for_choosing_brands from fact_survey_responses 
where Current_brands <> 'codeX'
group by Reasons_for_choosing_brands order by count(Respondent_ID) desc;
----------------------------------------------------------------------------------------------------------------------------------
-- Marketing Channels and Brand Awareness:
-- 4a Which marketing channel can be used to reach more customers?
select Marketing_channels ,count(f.respondent_id) Total_respondents from 
fact_survey_responses f 
join dim_repondents r 
on r.Respondent_ID=f.Respondent_ID
group by Marketing_channels 
order by Total_respondents desc;
----------------------------------------------------------------------------------------------------------------------------------
-- 4b How effective are different marketing strategies and channels in reaching our customers?
with cte_1 as(select Marketing_channels,count(f.respondent_id) yes_respondents
from fact_survey_responses f
where Heard_before="yes"
group by Marketing_channels
order by yes_respondents),
cte_2 as(select Marketing_channels,count(f.respondent_id) Total_respondents
from fact_survey_responses f
group by Marketing_channels
order by Total_respondents)
select *, round((yes_respondents/Total_respondents)*100,2) Reach_pct
from cte_1 join cte_2 on cte_1.marketing_channels=cte_2.marketing_channels
order by Reach_pct;
----------------------------------------------------------------------------------------------------------------------------------
-- Brand Penetration:
-- 5a What do people think about our brand? (overall rating)
 Select count(respondent_id), Brand_perception , Current_brands from fact_survey_responses
  where Current_brands = 'codex' group by Brand_perception order by Brand_perception desc;
  ----------------------------------------------------------------------------------------------------------------------------------
  -- 5b Which cities do we need to focus more on?
 select city,count(r.respondent_id) respondents
 from dim_cities d 
 join dim_repondents r on
 d.city_id = r.city_id
 join fact_survey_responses f on 
 r.respondent_id = f.respondent_ID
 where Current_brands = 'codex' and Brand_perception <> 'positive'
 group by City
 order by respondents desc;
 ----------------------------------------------------------------------------------------------------------------------------------
-- Purchase Behavior:
-- 6a Where do respondents prefer to purchase energy drinks?
 select count(Respondent_ID), Purchase_location from fact_survey_responses
 group by Purchase_location order by Purchase_location asc;
 ----------------------------------------------------------------------------------------------------------------------------------
 -- 6b What are the typical consumption situations for energy drinks among respondents?
 select count(Respondent_ID), Typical_consumption_situations from fact_survey_responses
 group by Typical_consumption_situations order by Typical_consumption_situations desc;
 ----------------------------------------------------------------------------------------------------------------------------------

 -- 6c What factors influence respondents' purchase decisions, such as price range and limited edition packaging ;
 Select price_range, Limited_edition_packaging, count(Respondent_ID) from fact_survey_responses
 group by Price_range,Limited_edition_packaging order by Price_range desc;
 ----------------------------------------------------------------------------------------------------------------------------------
 -- Product Development
 -- 7 Which area of business should we focus more on our product development? (Branding/taste/availability)
  Select count(Respondent_ID), Reasons_for_choosing_brands  from fact_survey_responses
  where Reasons_for_choosing_brands in ('Brand reputation' , 'Taste/flavor preference' , 'Availability')
 group by Reasons_for_choosing_brands order by count(Respondent_ID) asc;
 ----------------------------------------------------------------------------------------------------------------------------------
 -- Additional Query
 select Taste_experience,Consume_frequency, count(respondent_id) from fact_survey_responses
where Consume_frequency = 'Daily'
group by Taste_experience,Consume_frequency
having count(Respondent_ID) > 100
----------------------------------------------------------------------------------------------------------------------------------