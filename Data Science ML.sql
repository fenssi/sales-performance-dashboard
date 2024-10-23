create table transaction_detail (po_number text, transaction_date date, order_id text, 
				order_status text, payment_group text, payment_method text, shipping_agency text, 
				shipping_cost text, total_project_value bigint, voucher_val text, voucher_code text,
				revenue integer, seller_id text,seller_category text, buyer_id text)


create table order_detail (order_id text, product_id text, quantity integer, price_total integer, 
							free_shipping boolean, ppn integer, weight_total integer, unit text, weight_unit text)




--change data type
alter table transaction_detail
alter column order_id type integer

select *
	from transaction_detail


---MONTHLY TOTAL ORDER
select
	extract(month from transaction_date) as monthly,
	sum(revenue) as total_gmv
from transaction_detail
group by extract(month from transaction_date)


---OVERVIEW (CTE)
with buyer_table as (
	select trx.transaction_date,
			trx.order_id,
			trx.order_status,
			trx.revenue,
			trx.buyer_id,
			trx.seller_id,
			trx.seller_category,
			u.flag
	from transaction_detail trx
	inner join  users u
	on trx.buyer_id = u.uid
	where trx.order_status = 'Selesai'
			and trx.buyer_id is not null
			and trx.seller_id is not null
), 
	seller_table as (
	select trx.transaction_date,
			trx.order_id,
			trx.order_status,
			trx.revenue,
			trx.buyer_id,
			trx.seller_id,
			trx.seller_category,
			u.flag
	from transaction_detail trx
	inner join  users u
	on trx.seller_id = u.uid
	where trx.order_status = 'Selesai'
			and trx.buyer_id is not null
			and trx.seller_id is not null
),
	combined_table as (
	select *
	from buyer_table
union all
	select *
	from seller_table
)
select 
	ct.transaction_date,
	ct.order_id,
	ct.order_status,
	ct.revenue,
	ct.buyer_id,
	ct.seller_id,
	ct.seller_category,
	ct.flag,
	pd.product_name,
	pd.main_cat,
	pd.sub_cat1,
	pd.price_per_item,
	pd.rating,
	pd.brand,
	od.product_id,
	od.quantity,
	od.price_total,
	od.free_shipping
from combined_table ct
inner join order_detail od on ct.order_id = od.order_id
inner join products pd on pd.product_id = od.product_id
where ct.order_id is not null


---PRODUCT DETAIL
select pd.product_id,
		pd.product_name,
		pd.main_cat,
		pd.sub_cat1,
		pd.price_per_item,
		pd.rating,
		pd.brand,
		od.order_id,
		od.quantity,
		od.price_total,
		od.free_shipping,
		od.price_total
from products pd
left join order_detail od
on pd.product_id = od.product_id
where pd.product_id is not null
	and pd.main_cat is not null
	and od.order_id is not null



select *
from transaction_detail

select *
from products

select *
from order_detail
