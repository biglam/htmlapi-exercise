class DBBase

  attr_accessor :id

  def self.attributes(attrs)
    @attributes = attrs
    attrs.keys.each do |attr|
      attr_accessor attr
    end
  end

  def self.get_attributes
    @attributes
  end

  def self.table_name
    @table_name ||= begin
      case
        when name[-1] == 'y'
          name[0...-1] + 'ies'
        when name[-1] == 'x'
          name + 'es'
        when name[-2..-1] == 'sh'
          name + 'es'
        else
          name + 's'
      end.downcase
    end
  end

  def self.run_sql(sql)
    conn = PG.connect(dbname: 'cookbook', host: 'localhost')
    begin
      result = conn.exec(sql)
    ensure
      conn.close
    end
    result
  end

  def self.all(conditions={})
    where = conditions.map { |attribute, value| "#{attribute} = #{sql_sanitize(value, get_attributes[attribute])}" }.join(' AND ')
    where = "WHERE #{where}" unless where.empty?

    results = run_sql("SELECT #{table_name}.* FROM #{table_name} #{where}")
    results.map { |result| self.new(result) }
  end

  def self.find(id)
    result = run_sql("SELECT #{table_name}.* FROM #{table_name} WHERE id = #{sql_sanitize(id, :integer)}").first
    self.new(result) if result
  end

  def self.sql_sanitize(value, type)
    case type
      when :string
        "'#{value.to_s.gsub("'", "''")}'"
      when :text
        "'#{value.to_s.gsub("'", "''")}'"
      when :integer
        value.to_i
      when :decimal
        value.to_f
      else
        raise "Unrecognised data type `#{type}`"
    end
  end

  def initialize(params={})
    params.keys.each do |key|
      instance_variable_set("@#{key}", params[key])
    end
  end

  def attributes
    self.class.get_attributes
  end

  def table_name
    self.class.table_name
  end

  def run_sql(sql)
    self.class.run_sql(sql)
  end

  def sql_sanitize(value, type)
    self.class.sql_sanitize(value, type)
  end

  def save
    if id.nil?
      sql_fields = []
      sql_values = []
      attributes.each do |attribute, type|
        sql_fields << attribute
        sql_values << sql_sanitize(self.send(attribute), type)
      end

      sql = "INSERT INTO #{table_name} (#{sql_fields.join(', ')}) VALUES (#{sql_values.join(', ')}) RETURNING id"
      self.id = run_sql(sql).first['id']

    else

      sql_fields_and_values = attributes.map do |attribute, type|
        "#{attribute} = #{sql_sanitize(self.send(attribute), type)}"
      end

      sql = "UPDATE #{table_name} SET #{sql_fields_and_values.join(', ')} WHERE id = #{sql_sanitize(id, :integer)}"
      run_sql(sql)
    end

  end

  def update_attributes(attrs)
    attrs.each do |attribute, value|
      self.send("#{attribute}=", value)
    end
    save
  end

  def destroy
    run_sql("DELETE FROM #{table_name} WHERE id = #{sql_sanitize(id, :integer)}")
  end

end
