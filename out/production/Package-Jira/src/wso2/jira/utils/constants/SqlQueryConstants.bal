package src.wso2.jira.utils.constants;

const string QUERY_SELECT_ALL = "SELECT * FROM products";
const string QUERY_SEARCH  = "SELECT * FROM products WHERE MATCH (keywords) " + "AGAINST (? IN BOOLEAN MODE)";
const string QUERY_LATEST_PRODUCT = "SELECT * FROM products WHERE product_name = ? ORDER BY released_date desc LIMIT 1";
const string QUERY_PRODUCT_VERSION = "SELECT * FROM products WHERE product_name = ? AND product_version = ?";
const string QUERY_INSERT_PRODUCT = "INSERT INTO products (product_name, product_version, download_path_param, kernel_version, wum_supported,long_name,keywords,md5,released_date)" +
                                    " values(?,?,?,?,?,?,?,?,?)";
const string QUERY_PRODUCT_NAMES = "SELECT DISTINCT product_name FROM products where wum_supported = 1";
const string QUERY_UPDATE = "UPDATE products SET product_name = ?, product_version = ?, download_path_param = ?, kernel_version = ?, wum_supported = ?, long_name = ?, keywords = ?, md5 = ?, released_date = ? where product_name = ? AND product_version = ?";