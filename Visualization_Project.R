customers <- read_csv("~/Downloads/Data/Data_Science_Visualization/archive/olist_customers_dataset.csv")
names(customers)[3] <- "geolocation_zip_code_prefix"
location <- read_csv("~/Downloads/Data/Data_Science_Visualization/archive/olist_geolocation_dataset.csv")
cust_location <- location %>% 
  inner_join(customers,by="geolocation_zip_code_prefix") %>% 
  distinct(customer_id,customer_unique_id, .keep_all=TRUE)

orders <- read_csv("~/Downloads/Data/Data_Science_Visualization/archive/olist_orders_dataset.csv")

orders_merge <- orders %>% 
  inner_join(cust_location,by="customer_id")

reviews <- read_csv("~/Downloads/Data/Data_Science_Visualization/archive/olist_order_reviews_dataset.csv")

reviews_merge <- reviews %>% 
  inner_join(orders_merge,by='order_id')

payments <- read_csv("~/Downloads/Data/Data_Science_Visualization/archive/olist_order_payments_dataset.csv")

payments_merge <- payments %>% 
  inner_join(reviews_merge,by='order_id') %>% 
  distinct(customer_id,customer_unique_id, .keep_all=TRUE) %>% 
  select(payment_type,review_score,order_status,order_estimated_delivery_date,geolocation_zip_code_prefix,
         geolocation_lat,geolocation_lng,customer_city,customer_state,payment_value,order_id) %>% 
  mutate(year=substr(order_estimated_delivery_date, 1, 4))

order_items <- read_csv("~/Downloads/Data/Data_Science_Visualization/archive/olist_order_items_dataset.csv")

final <- order_items %>% 
  inner_join(payments_merge,by='order_id') %>% 
  distinct(order_id,.keep_all=TRUE) %>% 
  select(-(1:5))

attach(final)
table(customer_city)

write.csv(final, "~/Downloads/Data/Data_Science_Visualization/Brazilian_Commerce.csv", row.names = FALSE)
