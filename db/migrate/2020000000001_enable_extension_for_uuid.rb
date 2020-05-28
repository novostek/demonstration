class EnableExtensionForUuid < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'uuid-ossp'
    #enable_extension 'pgcrypto'
    execute 'CREATE EXTENSION pgcrypto WITH SCHEMA pg_catalog;'
  end
end
