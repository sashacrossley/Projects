require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    # ...
    self.class_name.constantize
  end

  def table_name
    # ...
    self.class_name.downcase + "s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    # ...
    if options.empty?
      @foreign_key = (name.to_s.singularize.underscore + "_id").to_sym
      @primary_key = :id
      @class_name = name.to_s.singularize.camelcase
    else
      @foreign_key = options[:foreign_key]
      @class_name = options[:class_name]
      @primary_key = options[:primary_key]
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    # ...
    if options.empty?
      @foreign_key = (self_class_name.to_s.singularize.underscore + "_id").to_sym
      @primary_key = :id
      @class_name = name.to_s.singularize.camelcase
    else
      @foreign_key = options[:foreign_key]
      @class_name = options[:class_name]
      @primary_key = options[:primary_key]
    end
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    # ...
  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  extend Associatable
  # Mixin Associatable here...
end
