    SELECT p.ID 'code',
    p.post_title 'name',
    p.post_content 'description',
    CONCAT((SELECT option_value FROM wp_options o WHERE o.option_name = "siteurl"), "/wp-content/uploads/", am.meta_value) AS siteurl,
    GROUP_CONCAT(cat.name SEPARATOR ' | ') 'category',
    MAX(CASE WHEN meta.meta_key = '_sku' THEN meta.meta_value END) 'code_sku',
    MAX(CASE WHEN meta.meta_key = '_price' THEN meta.meta_value END) 'price',
    MAX(CASE WHEN meta.meta_key = '_regular_price' THEN meta.meta_value END) 'discount',
    MAX(CASE WHEN meta.meta_key = '_stock' THEN meta.meta_value END) 'stock',
    MAX(CASE WHEN meta.meta_key = '_thumbnail_id' THEN meta.meta_value END) 'image_id'
    FROM wp_posts AS p
    LEFT JOIN wp_postmeta AS meta ON p.ID = meta.post_ID
    LEFT JOIN wp_postmeta pm ON pm.post_id = p.ID AND pm.meta_key = '_thumbnail_id'
    LEFT JOIN wp_postmeta am ON am.post_id = pm.meta_value AND am.meta_key = '_wp_attached_file'
    LEFT JOIN
    (
    SELECT pp.id,
    GROUP_CONCAT(t.name SEPARATOR ' , ') AS name
    FROM wp_posts AS pp
    JOIN wp_term_relationships tr ON pp.id = tr.object_id
    JOIN wp_term_taxonomy tt ON tr.term_taxonomy_id = tt.term_taxonomy_id
    JOIN wp_terms t ON tt.term_id = t.term_id
    || tt.parent = t.term_id
    WHERE tt.taxonomy = 'product_cat'
    GROUP BY pp.id, tt.term_id
    ) cat ON p.id = cat.id
    WHERE (p.post_type = 'product' OR p.post_type = 'product_variation')
    AND meta.meta_key IN ('_sku', '_price', '_regular_price', '_stock', '_thumbnail_id')
    AND meta.meta_value is not null
    GROUP BY p.ID, p.post_title, p.post_content, am.meta_value



SELECT p.ID, CONCAT((SELECT option_value FROM wp_options o WHERE o.option_name = "siteurl"), "/wp-content/uploads/", am.meta_value) AS siteurl
FROM wp_posts p
LEFT JOIN wp_postmeta pm ON pm.post_id = p.ID AND pm.meta_key = '_thumbnail_id'
LEFT JOIN wp_postmeta am ON am.post_id = pm.meta_value AND am.meta_key = '_wp_attached_file'
WHERE p.post_type = 'product'  AND p.post_status = 'publish' AND am.meta_value IS NOT NULL



















SELECT p.ID 'code',
p.post_title 'name',
p.post_content 'description',
am.meta_value 'image'
GROUP_CONCAT(cat.name SEPARATOR ' | ') 'category',
MAX(CASE WHEN meta.meta_key = '_sku' THEN meta.meta_value END) 'code_sku',
MAX(CASE WHEN meta.meta_key = '_price' THEN meta.meta_value END) 'price',
MAX(CASE WHEN meta.meta_key = '_regular_price' THEN meta.meta_value END) 'discount',
MAX(CASE WHEN meta.meta_key = '_stock' THEN meta.meta_value END) 'stock',
MAX(CASE WHEN meta.meta_key = '_thumbnail_id' THEN meta.meta_value END) 'image_id'
FROM wp_posts AS p
JOIN wp_postmeta AS meta ON p.ID = meta.post_ID AND pm.meta_key = '_thumbnail_id' 
LEFT JOIN wp_postmeta am ON am.post_id = pm.meta_value AND am.meta_key = '_wp_attached_file' 
LEFT JOIN
(
SELECT pp.id,
GROUP_CONCAT(t.name SEPARATOR ' , ') AS name
FROM wp_posts AS pp
JOIN wp_term_relationships tr ON pp.id = tr.object_id
JOIN wp_term_taxonomy tt ON tr.term_taxonomy_id = tt.term_taxonomy_id
JOIN wp_terms t ON tt.term_id = t.term_id || tt.parent = t.term_id
WHERE tt.taxonomy = 'product_cat'
GROUP BY pp.id, tt.term_id
) cat ON p.id = cat.id

WHERE (p.post_type = 'product' OR p.post_type = 'product_variation')
AND meta.meta_key IN ('_sku', '_price', '_regular_price', '_stock', '_thumbnail_id')
AND meta.meta_value is not null
GROUP BY p.ID





SELECT 
am.meta_value 'image' FROM wp_posts p 
LEFT JOIN wp_postmeta pm ON pm.post_id = p.ID AND pm.meta_key = '_thumbnail_id' 
LEFT JOIN wp_postmeta am ON am.post_id = pm.meta_value AND am.meta_key = '_wp_attached_file' 

WHERE p.post_type = 'product' AND p.post_status = 'publish'




SELECT p.*, pm2.meta_value as image_file FROM (
  SELECT 
    p.ID,
    p.post_title,
    'post_content',
    'post_excerpt',
    t.name AS product_category,
    t.term_id AS product_id,
    t.slug AS product_slug,
    tt.term_taxonomy_id AS tt_term_taxonomia,
    tr.term_taxonomy_id AS tr_term_taxonomia,
    MAX(CASE WHEN pm1.meta_key = '_price' then pm1.meta_value ELSE NULL END) as price,
    MAX(CASE WHEN pm1.meta_key = '_sku' then pm1.meta_value ELSE NULL END) as sku,
    MAX(CASE WHEN pm1.meta_key = '_thumbnail_id' then pm1.meta_value ELSE NULL END) as thumbnail_id
  FROM wp_posts p 
  LEFT JOIN wp_postmeta pm1 ON pm1.post_id = p.ID
  LEFT JOIN wp_term_relationships AS tr ON tr.object_id = p.ID
  JOIN wp_term_taxonomy AS tt ON tt.taxonomy = 'product_cat' AND tt.term_taxonomy_id = 
  tr.term_taxonomy_id 
  JOIN wp_terms AS t ON t.term_id = tt.term_id
  WHERE p.post_type in('product', 'product_variation') AND p.post_status = 'publish' AND p.post_content <> ''
  GROUP BY p.ID,p.post_title
) as p
JOIN wp_postmeta pm2 ON pm2.post_id = p.thumbnail_id
WHERE pm2.meta_key = '_wp_attached_file'







SELECT p.ID 'code',
    p.post_title 'name',
    p.post_content 'description',
    CONCAT((SELECT option_value FROM wp_options o WHERE o.option_name = "siteurl"), "/wp-content/uploads/", am.meta_value) AS image,
    GROUP_CONCAT(cat.name SEPARATOR ' | ') 'category',
    MAX(CASE WHEN meta.meta_key = '_sku' THEN meta.meta_value END) 'code_sku',
    MAX(CASE WHEN meta.meta_key = '_price' THEN meta.meta_value END) 'price',
    MAX(CASE WHEN meta.meta_key = '_regular_price' THEN meta.meta_value END) 'discount',
    MAX(CASE WHEN meta.meta_key = '_stock' THEN meta.meta_value END) 'stock',
    MAX(CASE WHEN meta.meta_key = '_thumbnail_id' THEN meta.meta_value END) 'image_id',
    MAX(CASE WHEN meta.meta_key = 'total_sales' THEN meta.meta_value END) 'sales'
    FROM wp_posts AS p
    LEFT JOIN wp_postmeta AS meta ON p.ID = meta.post_ID
    LEFT JOIN wp_postmeta pm ON pm.post_id = p.ID AND pm.meta_key = '_thumbnail_id'
    LEFT JOIN wp_postmeta am ON am.post_id = pm.meta_value AND am.meta_key = '_wp_attached_file'
    LEFT JOIN
    (
    SELECT pp.id,
    GROUP_CONCAT(t.name SEPARATOR ' , ') AS name
    FROM wp_posts AS pp
    JOIN wp_term_relationships tr ON pp.id = tr.object_id
    JOIN wp_term_taxonomy tt ON tr.term_taxonomy_id = tt.term_taxonomy_id
    JOIN wp_terms t ON tt.term_id = t.term_id
    || tt.parent = t.term_id
    WHERE tt.taxonomy = 'product_cat'
    GROUP BY pp.id, tt.term_id
    ) cat ON p.id = cat.id
    WHERE (p.post_type = 'product' OR p.post_type = 'product_variation')
    AND meta.meta_key IN ('_sku', '_price', '_regular_price', '_stock', '_thumbnail_id', 'total_sales')
    AND meta.meta_value is not null
    GROUP BY p.ID, p.post_title, p.post_content, am.meta_value
_product_attributes

    SELECT p.ID 'code', 
    p.post_title 'name', 
    p.post_content 'description',
    p.guid 'images', 
    CONCAT((SELECT option_value FROM wp_options o WHERE o.option_name = 'siteurl'), '/wp-content/uploads/', am.meta_value) AS image, 
    GROUP_CONCAT(cat.name SEPARATOR ' | ') 'category', 
    MAX(CASE WHEN meta.meta_key = '_price' THEN meta.meta_value END) 'price', 
    MAX(CASE WHEN meta.meta_key = '_regular_price' THEN meta.meta_value END) 'discount',
    MAX(CASE WHEN meta.meta_key = '_stock' THEN meta.meta_value END) 'stock'
    MAX(CASE WHEN meta.meta_key = '_product_attributes' THEN meta.meta_value END) 'atributes'
    FROM wp_posts AS p LEFT JOIN wp_postmeta AS meta ON p.ID = meta.post_ID 
    LEFT JOIN wp_postmeta pm ON pm.post_id = p.ID AND pm.meta_key = '_thumbnail_id' 
    LEFT JOIN wp_postmeta am ON am.post_id = pm.meta_value AND am.meta_key = '_wp_attached_file' 
    LEFT JOIN ( SELECT pp.id, GROUP_CONCAT(t.name SEPARATOR ' , ') 
    AS name FROM wp_posts AS pp JOIN wp_term_relationships tr ON pp.id = tr.object_id 
    JOIN wp_term_taxonomy tt ON tr.term_taxonomy_id = tt.term_taxonomy_id 
    JOIN wp_terms t ON tt.term_id = t.term_id || tt.parent = t.term_id 
    WHERE tt.taxonomy = 'product_cat' GROUP BY pp.id, tt.term_id ) cat ON p.id = cat.id 
    WHERE (p.id = "+GoodID+") 
    AND meta.meta_key IN ('_sku', '_price', '_regular_price', '_stock', '_thumbnail_id') 
    AND meta.meta_value is not null GROUP BY p.ID, p.post_title, p.post_content, am.meta_value LIMIT 1
    UNION
    SELECT p.guid 'image' FROM wp_posts WHERE p.post_parent = "+GoodID+"


    SELECT p.ID FROM wp_posts as p
    INNER JOIN wp_postmeta as pm ON p.ID = pm.post_id
    INNER JOIN wp_postmeta as pm2 ON p.ID = pm2.post_id
    WHERE p.post_type LIKE 'product_variation'
    AND p.post_status LIKE 'publish'
    AND pm.meta_key LIKE 'attribute_pa_color'
    AND pm.meta_value = 'black'
    AND pm2.meta_value = 'yes'


    SELECT p.ID 'code', p.post_title 'name', CONCAT((SELECT option_value FROM wp_options o WHERE o.option_name = 'siteurl'), '/wp-content/uploads/', am.meta_value) AS image, GROUP_CONCAT(cat.name SEPARATOR ' | ') 'category', MAX(CASE WHEN meta.meta_key = '_price' THEN meta.meta_value END) 'price', MAX(CASE WHEN meta.meta_key = '_regular_price' THEN meta.meta_value END) 'discount', MAX(CASE WHEN meta.meta_key = 'total_sales' THEN meta.meta_value END) 'sales' FROM wp_posts AS p LEFT JOIN wp_postmeta AS meta ON p.ID = meta.post_ID LEFT JOIN wp_postmeta pm ON pm.post_id = p.ID AND pm.meta_key = '_thumbnail_id' LEFT JOIN wp_postmeta am ON am.post_id = pm.meta_value AND am.meta_key = '_wp_attached_file' LEFT JOIN ( SELECT pp.id, GROUP_CONCAT(t.name SEPARATOR ' , ') AS name FROM wp_posts AS pp JOIN wp_term_relationships tr ON pp.id = tr.object_id JOIN wp_term_taxonomy tt ON tr.term_taxonomy_id = tt.term_taxonomy_id JOIN wp_terms t ON tt.term_id = t.term_id || tt.parent = t.term_id WHERE tt.taxonomy = 'product_cat' GROUP BY pp.id, tt.term_id ) cat ON p.id = cat.id WHERE (p.post_type = 'product' OR p.post_type = 'product_variation') AND p.post_status = 'publish' AND meta.meta_key IN ('_price', '_regular_price') AND meta.meta_value is not null GROUP BY p.ID, p.post_title, p.post_content, am.meta_value





SELECT p.ID 'code', p.post_title 'name', p.post_content 'description', p.post_excerpt 'description_excerpt',  
CONCAT((SELECT option_value FROM wp_options o WHERE o.option_name = 'siteurl'), '/wp-content/uploads/', am.meta_value) AS image,
cat.name 'main-category',
subcat.name 'sub-category',
CONCAT(cat.name, '|', subcat.name) AS 'category',
MAX(CASE WHEN meta.meta_key = '_price' THEN meta.meta_value END) 'price',
MAX(CASE WHEN meta.meta_key = '_regular_price' THEN meta.meta_value END) 'discount',
MAX(CASE WHEN meta.meta_key = '_stock' THEN meta.meta_value END) 'stock',
MAX(CASE WHEN meta.meta_key = 'total_sales' THEN meta.meta_value END) 'sales' ,
MAX(CASE WHEN meta.meta_key = '_stock_status' THEN meta.meta_value END) 'stock_status' 
FROM wp_posts AS p LEFT JOIN wp_postmeta AS meta ON p.ID = meta.post_ID
LEFT JOIN wp_postmeta pm ON pm.post_id = p.ID AND pm.meta_key = '_thumbnail_id'
LEFT JOIN wp_postmeta am ON am.post_id = pm.meta_value AND am.meta_key = '_wp_attached_file'



LEFT JOIN ( SELECT pp.id, tp.name
AS name FROM wp_posts AS pp 

JOIN wp_term_relationships AS tr
ON pp.id = tr.object_id 

JOIN wp_term_taxonomy AS tt 
ON tr.term_taxonomy_id = tt.term_taxonomy_id 

JOIN wp_terms t 
ON tt.term_id = t.term_id

JOIN wp_terms tp 
ON tt.parent = tp.term_id

WHERE tt.taxonomy = 'product_cat'

GROUP BY pp.id, tt.term_id, tp.term_id) cat ON p.id = cat.id

LEFT JOIN ( SELECT pp.id, tp.name
AS name FROM wp_posts AS pp 

JOIN wp_term_relationships AS tr
ON pp.id = tr.object_id 

JOIN wp_term_taxonomy AS tt 
ON tr.term_taxonomy_id = tt.term_taxonomy_id 

JOIN wp_terms t 
ON tt.term_id = t.term_id

JOIN wp_terms tp 
ON tt.parent = tp.term_id

WHERE tt.taxonomy = 'product_cat'

GROUP BY pp.id, tt.term_id, tp.term_id) subcat ON p.id = subcat.id




WHERE (p.id = ?) AND meta.meta_key IN ('_sku', '_price', '_regular_price', '_stock', '_thumbnail_id', 'total_sales', '_stock_status')
AND meta.meta_value is not null
GROUP BY p.ID, p.post_title, p.post_content, am.meta_value LIMIT 1


SELECT tp.name Cat, t.name Subcat FROM wp_term_taxonomy AS tt, wp_terms AS t, wp_terms AS tp WHERE tt.taxonomy = 'product_cat' AND tt.term_id = t.term_id AND tt.parent = tp.term_id ORDER BY Cat, Subcat




















SELECT p.ID 'code', p.post_title 'name', 
CONCAT(
    (SELECT option_value
    FROM wp_options o
    WHERE o.option_name = 'siteurl'), '/wp-content/uploads/', am.meta_value) AS image, 
        cat.name 'main-category', 
    subcat.name 'sub-category',
     CONCAT(cat.name, ' | ', subcat.name) AS 'category',  



     MAX(CASE WHEN meta.meta_key = '_price' THEN
    meta.meta_value END) 'price', MAX(CASE
    WHEN meta.meta_key = '_regular_price' THEN
    meta.meta_value END) 'discount',MAX(CASE
    WHEN meta.meta_key = '_stock_status' THEN
    meta.meta_value END) 'stock_status'
FROM wp_posts AS p
LEFT JOIN wp_postmeta AS meta
    ON p.ID = meta.post_ID
LEFT JOIN wp_postmeta pm
    ON pm.post_id = p.ID
        AND pm.meta_key = '_thumbnail_id'
LEFT JOIN wp_postmeta am
    ON am.post_id = pm.meta_value
        AND am.meta_key = '_wp_attached_file'

LEFT JOIN 
    (SELECT pp.id,
         tp.name AS name
    FROM wp_posts AS pp
    JOIN wp_term_relationships AS tr
        ON pp.id = tr.object_id
    JOIN wp_term_taxonomy AS tt
        ON tr.term_taxonomy_id = tt.term_taxonomy_id
    JOIN wp_terms t
        ON tt.term_id = t.term_id
    JOIN wp_terms tp
        ON tt.parent = tp.term_id
    WHERE tt.taxonomy = 'product_cat'
    GROUP BY  pp.id, tt.term_id, tp.term_id) cat
    ON p.id = cat.id

LEFT JOIN 
    (SELECT pp.id,
         t.name AS name
    FROM wp_posts AS pp
    JOIN wp_term_relationships AS tr
        ON pp.id = tr.object_id
    JOIN wp_term_taxonomy AS tt
        ON tr.term_taxonomy_id = tt.term_taxonomy_id
    JOIN wp_terms t
        ON tt.term_id = t.term_id
    JOIN wp_terms tp
        ON tt.parent = tp.term_id
    WHERE tt.taxonomy = 'product_cat'
    GROUP BY  pp.id, tt.term_id, tp.term_id) subcat
    ON p.id = subcat.id

WHERE (p.post_type = 'product'
        OR p.post_type = 'product_variation' )
        AND p.post_title LIKE N'%" + name + "%'
        AND p.post_status = 'publish'
        AND meta.meta_key IN ('_price', '_regular_price', '_stock_status')
        AND meta.meta_value is NOT null
GROUP BY  p.ID, p.post_title, p.post_content, am.meta_value





SELECT p.ID 'code', p.post_title 'name', p.post_content 'description', p.post_excerpt 'description_excerpt', 
CONCAT(
    (SELECT option_value
    FROM wp_options o
    WHERE o.option_name = 'siteurl'), '/wp-content/uploads/', am.meta_value) AS image, 

    cat.name 'main-category', subcat.name 'sub-category', CONCAT(cat.name, ' | ', subcat.name) AS 'category', 

    MAX(CASE
    WHEN meta.meta_key = '_price' THEN
    meta.meta_value END) 'price', MAX(CASE
    WHEN meta.meta_key = '_regular_price' THEN
    meta.meta_value END) 'discount', MAX(CASE
    WHEN meta.meta_key = '_stock' THEN
    meta.meta_value END) 'stock', MAX(CASE
    WHEN meta.meta_key = 'total_sales' THEN
    meta.meta_value END) 'sales' , MAX(CASE
    WHEN meta.meta_key = '_stock_status' THEN
    meta.meta_value END) 'stock_status'
FROM wp_posts AS p
LEFT JOIN wp_postmeta AS meta
    ON p.ID = meta.post_ID
LEFT JOIN wp_postmeta pm
    ON pm.post_id = p.ID
        AND pm.meta_key = '_thumbnail_id'
LEFT JOIN wp_postmeta am
    ON am.post_id = pm.meta_value
        AND am.meta_key = '_wp_attached_file'

LEFT JOIN 
    (SELECT pp.id, GROUP_CONCAT(tp.name SEPARATOR ' , ') AS name
    FROM wp_posts AS pp
    JOIN wp_term_relationships AS tr ON pp.id = tr.object_id
    JOIN wp_term_taxonomy AS tt ON tr.term_taxonomy_id = tt.term_taxonomy_id
    JOIN wp_terms tp ON tt.parent = tp.term_id
    JOIN wp_terms t ON tt.term_id = t.term_id || tt.parent = t.term_id 

    WHERE tt.taxonomy = 'product_cat'
    GROUP BY  pp.id, tt.term_id, tp.term_id) cat
    ON p.id = cat.id

LEFT JOIN 
    (SELECT pp.id, GROUP_CONCAT(t.name SEPARATOR ' , ')  AS name
    FROM wp_posts AS pp
    JOIN wp_term_relationships AS tr ON pp.id = tr.object_id
    JOIN wp_term_taxonomy AS tt ON tr.term_taxonomy_id = tt.term_taxonomy_id   
    JOIN wp_terms tp ON tt.parent = tp.term_id
    JOIN wp_terms t ON tt.term_id = t.term_id || tt.parent = t.term_id 
    WHERE tt.taxonomy = 'product_cat'
    GROUP BY  pp.id, tt.term_id, tp.term_id) subcat
    ON p.id = subcat.id


WHERE (p.id = ?)
        AND meta.meta_key IN ('_sku', '_price', '_regular_price', '_stock', '_thumbnail_id', 'total_sales', '_stock_status')
        AND meta.meta_value is NOT null
GROUP BY  p.ID, p.post_title, p.post_content, am.meta_value LIMIT 1



SELECT ID,
         post_title,
         
    (SELECT wp_terms.name
    FROM wp_terms
    WHERE term_id= 
        (SELECT wp_postmeta.meta_value
        FROM wp_postmeta
        WHERE wp_postmeta.post_id = wp_posts.ID
                AND wp_postmeta.meta_key = '_yoast_wpseo_primary_category')) AS 'Primary Category' , 
    (SELECT group_concat(wp_terms.name separator ', ')
    FROM wp_terms
    INNER JOIN wp_term_taxonomy
        ON wp_terms.term_id = wp_term_taxonomy.term_id
    INNER JOIN wp_term_relationships wpr
        ON wpr.term_taxonomy_id = wp_term_taxonomy.term_taxonomy_id
    WHERE taxonomy= 'category'
            AND wp_posts.ID = wpr.object_id ) AS 'Categories' , 
    (SELECT group_concat(wp_terms.name separator ', ')
    FROM wp_terms
    INNER JOIN wp_term_taxonomy
        ON wp_terms.term_id = wp_term_taxonomy.term_id
    INNER JOIN wp_term_relationships wpr
        ON wpr.term_taxonomy_id = wp_term_taxonomy.term_taxonomy_id
    WHERE taxonomy= 'post_tag'
            AND wp_posts.ID = wpr.object_id ) AS 'Tags'
FROM wp_posts
WHERE post_type = 'product'
        AND post_status = 'publish'
ORDER BY  post_title



SELECT wp.id, wp.post_title, tt.parent, t.name, tp.name
FROM wp_posts wp 
INNER JOIN wp_term_relationships r ON wp.ID = r.object_id 
INNER JOIN wp_term_taxonomy tt ON r.term_taxonomy_id = tt.term_taxonomy_id 
INNER JOIN wp_terms t ON t.term_id = tt.term_id
INNER JOIN wp_terms tp ON tt.parent = tp.term_id
WHERE tt.taxonomy = 'product_cat'
AND wp.id = 157


    JOIN wp_terms t ON tt.term_id = t.term_id JOIN wp_terms tp ON tt.parent = tp.term_id