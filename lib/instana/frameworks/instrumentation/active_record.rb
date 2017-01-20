
require "instana/frameworks/instrumentation/mysql2_adapter"
require "instana/frameworks/instrumentation/postgresql_adapter"

if defined?(::ActiveRecord) && ::Instana.config[:active_record][:enabled]
  case ActiveRecord::Base.connection.adapter_name.downcase
  when 'mysql'
    ::Instana.logger.warn "Still undone: mysql"
  when 'mysql2'
    ::Instana.logger.warn "Instrumenting ActiveRecord (mysql2)"
    ActiveRecord::ConnectionAdapters::Mysql2Adapter.send(:include, ::Instana::Instrumentation::Mysql2Adapter)
  when 'postgresql'
    ::Instana.logger.warn "Instrumenting ActiveRecord (postgresql)"
    ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send(:include, ::Instana::Instrumentation::PostgreSQLAdapter)
  else
    ::Instana.logger.warn "Unsupported ActiveRecord adapter: #{ActiveRecord::Base.connection.adapter_name.downcase}"
  end
end
