import csv
import os

def generate_sql_inserts(csv_filepath):
    table_name = os.path.basename(csv_filepath).replace('.csv', '')
    
    sql_statements = []
    
    with open(csv_filepath, 'r', encoding='utf-8') as file:
        reader = csv.reader(file)
        
        headers = next(reader)
        columns = ', '.join(headers)
        
        for row in reader:
            values = []
            for value in row:
                if value == '' or value.upper() == 'NULL':
                    values.append('NULL')
                elif value.replace('.', '').replace('-', '').isdigit():
                    values.append(value)
                else:
                    escaped_value = value.replace("'", "''")
                    values.append(f"'{escaped_value}'")
            
            values_str = ', '.join(values)
            sql = f"INSERT INTO {table_name} ({columns}) VALUES ({values_str});"
            sql_statements.append(sql)
    
    return sql_statements

def process_all_csvs(data_folder, output_file):
    all_sql = []
    
    csv_files = [f for f in os.listdir(data_folder) if f.endswith('.csv')]
    
    for csv_file in csv_files:
        filepath = os.path.join(data_folder, csv_file)
        table_name = csv_file.replace('.csv', '')
        
        all_sql.append(f"\n-- {table_name.upper()} Table Insertions")
        
        statements = generate_sql_inserts(filepath)
        all_sql.extend(statements)
    
    """with open(output_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(all_sql))
    """
    print('\n'.join(all_sql))
    print(f"SQL statements printed")

if __name__ == "__main__":
    data_folder = "data"  # Folder containing CSV files
    output_file = "src/insertion.sql"  # Output SQL file
    
    process_all_csvs(data_folder, output_file)