TABLE_NAME = ARGV[1]
adif_file = File.open(ARGV[0], "r").read
sql_file = File.open(ARGV[0]+".sql", "a+")

body = adif_file.split("<EOH>")[1]

reports = body.split("<EOR>")
reports.pop

reports.each do |r|
  rep_hash = {}
  elements = r.split("<")
  elements.shift
  
  elements.each do |e|
    k,v = e.split(">")
    k = k.split(":")[0]
    rep_hash[k] = v.nil? ? '' : v.gsub("'", "''")
  end
  
  sql = "insert into #{TABLE_NAME} ('#{rep_hash.keys.join("','")}') values ('#{rep_hash.values.join("','")}');\n"
  sql_file << sql
end