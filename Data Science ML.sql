with buyer_table as (
	select trx.transaction_date,
			trx.order_id,
			trx.order_status,
			trx.revenue,
			trx.buyer_id,
			trx.seller_id,
			trx.seller_category,
			trx.voucher_val,
			u.flag,
			u.province,
			u.city
	from transaction_detail trx
	inner join  users u
	on trx.buyer_id = u.uid
	where trx.order_status = 'Selesai'
			and trx.order_id is not null
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
			trx.voucher_val,
			u.flag,
			u.province,
			u.city
	from transaction_detail trx
	inner join  users u
	on trx.seller_id = u.uid
	where trx.order_status = 'Selesai'
			and trx.order_id is not null
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
	ct.voucher_val,
	ct.flag,
	ct.province,
	ct.city,
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
