require 'type_mapper/version'

class TypeMapper
  def self.mappings
    @mappings ||= {}
  end

  def self.def_mapping(*types, &mapping_block)
    types.each do |t|
      mappings[t] = mapping_block
    end
  end

  def map(value)
    m = find_mapping!(value.class)
    instance_exec(value, &m)
  end
  alias_method :call, :map

  private

    def find_mapping!(type)
      mappings = self.class.mappings
      result = type.ancestors.find { |ancestor| mappings.has_key?(ancestor) }
      if result
        mappings.fetch(result)
      else
        raise MappingNotDefined, "No mapping defined for #{type}"
      end
    end

    class MappingNotDefined < StandardError; end
end
