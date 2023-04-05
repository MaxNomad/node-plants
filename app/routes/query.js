const get_home = (db) => {
    return new Promise((resolve, reject) => {
        db.query("SELECT p.ID 'code', p.post_title 'name', CONCAT((SELECT option_value FROM wp_options o WHERE o.option_name = 'siteurl'), '/wp-content/uploads/', am.meta_value) AS image, MAX(CASE WHEN meta.meta_key = '_price' THEN meta.meta_value END) 'price', MAX(CASE WHEN meta.meta_key = '_regular_price' THEN meta.meta_value END) 'discount', MAX(CASE WHEN meta.meta_key = 'total_sales' THEN meta.meta_value END) 'sales', MAX(CASE WHEN meta.meta_key = '_stock_status' THEN meta.meta_value END) 'stock_status' FROM wp_posts AS p LEFT JOIN wp_postmeta AS meta ON p.ID = meta.post_ID LEFT JOIN wp_postmeta pm ON pm.post_id = p.ID AND pm.meta_key = '_thumbnail_id' LEFT JOIN wp_postmeta am ON am.post_id = pm.meta_value AND am.meta_key = '_wp_attached_file' LEFT JOIN ( SELECT pp.id, GROUP_CONCAT(t.name SEPARATOR ' , ') AS name FROM wp_posts AS pp JOIN wp_term_relationships tr ON pp.id = tr.object_id JOIN wp_term_taxonomy tt ON tr.term_taxonomy_id = tt.term_taxonomy_id JOIN wp_terms t ON tt.term_id = t.term_id || tt.parent = t.term_id WHERE tt.taxonomy = 'product_cat' GROUP BY pp.id, tt.term_id ) cat ON p.id = cat.id WHERE (p.post_type = 'product' OR p.post_type = 'product_variation') AND p.post_status = 'publish' AND meta.meta_key IN ('_price', '_regular_price', 'total_sales', '_product_attributes', '_stock_status') AND meta.meta_value is not null GROUP BY p.ID, p.post_title, p.post_content, am.meta_value", (err, res) => {
            err ? reject(err) : resolve(res)
        })

    })
}

const get_search_items = (db, name) => {
    return new Promise((resolve, reject) => {
        db.query("SELECT p.ID 'code', p.post_title 'name', CONCAT((SELECT option_value FROM wp_options o WHERE o.option_name = 'siteurl'), '/wp-content/uploads/', am.meta_value) AS image, GROUP_CONCAT(cat.name SEPARATOR ', ') 'category', MAX(CASE WHEN meta.meta_key = '_sku' THEN meta.meta_value END) 'code_sku', MAX(CASE WHEN meta.meta_key = '_price' THEN meta.meta_value END) 'price', MAX(CASE WHEN meta.meta_key = '_regular_price' THEN meta.meta_value END) 'discount', MAX(CASE WHEN meta.meta_key = '_stock' THEN meta.meta_value END) 'stock', MAX(CASE WHEN meta.meta_key = '_thumbnail_id' THEN meta.meta_value END) 'image_id', MAX(CASE WHEN meta.meta_key = 'total_sales' THEN meta.meta_value END) 'sales', MAX(CASE WHEN meta.meta_key = '_stock_status' THEN meta.meta_value END) 'stock_status' FROM wp_posts AS p LEFT JOIN wp_postmeta AS meta ON p.ID = meta.post_ID LEFT JOIN wp_postmeta pm ON pm.post_id = p.ID AND pm.meta_key = '_thumbnail_id' LEFT JOIN wp_postmeta am ON am.post_id = pm.meta_value AND am.meta_key = '_wp_attached_file' LEFT JOIN ( SELECT pp.id, GROUP_CONCAT(t.name SEPARATOR ', ') AS name FROM wp_posts AS pp JOIN wp_term_relationships tr ON pp.id = tr.object_id JOIN wp_term_taxonomy tt ON tr.term_taxonomy_id = tt.term_taxonomy_id JOIN wp_terms t ON tt.term_id = t.term_id || tt.parent = t.term_id WHERE tt.taxonomy = 'product_cat' GROUP BY pp.id, tt.term_id ) cat ON p.id = cat.id WHERE (p.post_type = 'product' OR p.post_type = 'product_variation') AND p.post_status = 'publish' AND p.post_title LIKE N'%" + name + "%' AND meta.meta_key IN ('_sku', '_price', '_regular_price', '_stock', '_thumbnail_id', 'total_sales', '_stock_status') AND meta.meta_value is not null GROUP BY p.ID, p.post_title, p.post_content, am.meta_value", name, (err, res) => {
            err ? reject(err) : resolve(res)
        })

    })
}
const get_good = (db, good_ID) => {
    return new Promise((resolve, reject) => {
        db.query("SELECT p.ID 'code', p.post_title 'name', p.post_content 'description', p.post_excerpt 'description_excerpt', CONCAT((SELECT option_value FROM wp_options o WHERE o.option_name = 'siteurl'), '/wp-content/uploads/', am.meta_value) AS image, cat.name  'main-category', cat.subname  'sub-category', CONCAT(cat.name, ' | ', cat.subname) AS 'category', MAX(CASE WHEN meta.meta_key = '_sku' THEN meta.meta_value END) 'code_sku', MAX(CASE WHEN meta.meta_key = '_price' THEN meta.meta_value END) 'price', MAX(CASE WHEN meta.meta_key = '_regular_price' THEN meta.meta_value END) 'discount', MAX(CASE WHEN meta.meta_key = '_stock' THEN meta.meta_value END) 'stock', MAX(CASE WHEN meta.meta_key = '_thumbnail_id' THEN meta.meta_value END) 'image_id', MAX(CASE WHEN meta.meta_key = 'total_sales' THEN meta.meta_value END) 'sales', MAX(CASE WHEN meta.meta_key = '_stock_status' THEN meta.meta_value END) 'stock_status' FROM wp_posts AS p LEFT JOIN wp_postmeta AS meta ON p.ID = meta.post_ID LEFT JOIN wp_postmeta pm ON pm.post_id = p.ID AND pm.meta_key = '_thumbnail_id' LEFT JOIN wp_postmeta am ON am.post_id = pm.meta_value AND am.meta_key = '_wp_attached_file' LEFT JOIN ( SELECT pp.id, t.name AS name, tp.name AS subname FROM wp_posts AS pp JOIN wp_term_relationships tr ON pp.id = tr.object_id JOIN wp_term_taxonomy tt ON tr.term_taxonomy_id = tt.term_taxonomy_id JOIN wp_terms t ON tt.term_id = t.term_id || tt.parent = t.term_id JOIN wp_terms tp ON tt.term_id = tp.term_id WHERE tt.taxonomy = 'product_cat' GROUP BY pp.id, tt.term_id ) cat ON p.id = cat.id WHERE (p.post_type = 'product' OR p.post_type = 'product_variation' AND p.post_status = 'publish') AND p.ID = ? AND meta.meta_key IN ('_sku', '_price', '_regular_price', '_stock', '_thumbnail_id', 'total_sales', '_stock_status') AND meta.meta_value is not null GROUP BY p.ID, p.post_title, p.post_content, am.meta_value LIMIT 1", good_ID, (err, res) => {

            err ? reject(err) : resolve(res)
        })

    })
}
const get_good_images = (db, good_ID) => {
    return new Promise((resolve, reject) => {
        db.query("SELECT guid 'original', guid 'thumbnail' FROM wp_posts WHERE post_parent  = ?", good_ID, (err, res) => {
            err ? reject(err) : resolve(res)
        })

    })
}
const get_good_attr = (db, good_ID) => {
    return new Promise((resolve, reject) => {
        db.query("SELECT t.`term_id` AS 'AttributeValueID', REPLACE(REPLACE(tt.`taxonomy`, 'pa_', ''), '-', ' ') AS 'AttrName', t.`name` AS 'AttrValue' FROM `wp_posts` AS p INNER JOIN `wp_term_relationships` AS tr ON p.`ID` = tr.`object_id` INNER JOIN `wp_term_taxonomy` AS tt ON tr.`term_taxonomy_id` = tt.`term_id` AND tt.`taxonomy` LIKE 'pa_%' INNER JOIN `wp_terms` AS t ON tr.`term_taxonomy_id` = t.`term_id` WHERE p.`post_type` = 'product' AND p.`post_status` = 'publish' AND p.`ID` = ?", good_ID, (err, res) => {
            err ? reject(err) : resolve(res)
        })

    })
}


const QUERRY = `
SELECT p.ID 'code',
    p.post_title 'name',
    p.post_content 'description',
    p.post_excerpt 'description_excerpt',
    CONCAT((SELECT option_value FROM wp_options o WHERE o.option_name = "siteurl"), "/wp-content/uploads/", am.meta_value) AS image,
    GROUP_CONCAT(cat.name SEPARATOR ', ') 'category',
    MAX(CASE WHEN meta.meta_key = '_sku' THEN meta.meta_value END) 'code_sku',
    MAX(CASE WHEN meta.meta_key = '_price' THEN meta.meta_value END) 'price',
    MAX(CASE WHEN meta.meta_key = '_regular_price' THEN meta.meta_value END) 'discount',
    MAX(CASE WHEN meta.meta_key = '_stock' THEN meta.meta_value END) 'stock',
    MAX(CASE WHEN meta.meta_key = '_thumbnail_id' THEN meta.meta_value END) 'image_id',
    MAX(CASE WHEN meta.meta_key = 'total_sales' THEN meta.meta_value END) 'sales',
    MAX(CASE WHEN meta.meta_key = '_stock_status' THEN meta.meta_value END) 'stock_status'
    FROM wp_posts AS p
    LEFT JOIN wp_postmeta AS meta ON p.ID = meta.post_ID
    LEFT JOIN wp_postmeta pm ON pm.post_id = p.ID AND pm.meta_key = '_thumbnail_id'
    LEFT JOIN wp_postmeta am ON am.post_id = pm.meta_value AND am.meta_key = '_wp_attached_file'
    LEFT JOIN
    (
    SELECT pp.id, GROUP_CONCAT(t.name SEPARATOR ', ') AS name
    FROM wp_posts AS pp
    JOIN wp_term_relationships tr ON pp.id = tr.object_id
    JOIN wp_term_taxonomy tt ON tr.term_taxonomy_id = tt.term_taxonomy_id
    JOIN wp_terms t ON tt.term_id = t.term_id || tt.parent = t.term_id
    WHERE tt.taxonomy = 'product_cat'
    GROUP BY pp.id, tt.term_id
    ) cat ON p.id = cat.id
    WHERE (p.post_type = 'product' OR p.post_type = 'product_variation' AND p.post_status = 'publish')
    AND meta.meta_key IN ('_sku', '_price', '_regular_price', '_stock', '_thumbnail_id', 'total_sales', '_stock_status')
    AND meta.meta_value is not null
    GROUP BY p.ID, p.post_title, p.post_content, am.meta_value
`
const test_querry = (db) => {
    return new Promise((resolve, reject) => {
        db.query(QUERRY,157, (err, res) => {
            err ? reject(err) : resolve(res)
        })

    })
}

module.exports = { get_home, get_good, get_good_images, get_search_items, test_querry, get_good_attr };
