module ApplicationHelper
  def camunda_input(data, form)
    begin
      render partial: "bpm_fields/#{data[:category]}_field", locals: {form: form, key: data[:key], name: data[:name], mask: data[:mask], value: data[:value]}
    rescue
      render partial: "bpm_fields/string_field", locals: {form: form, key: data[:key], name: data[:name], mask: {}, value: data[:value]}
    end
  end

  def camunda_li_variable(data)
    begin
      render partial: "bpm_fields/li_variable_#{data[:category]}", locals: {data: data}
    rescue
      render partial: "bpm_fields/li_variable_string", locals: {data: data}
    end
  end

  def duration_word(count)
    if count.blank?
      return t('bpm.in_progress')
    elsif count < 1000
      return t('bpm.imediate')
    end
    value = (count || 0) / 1000
    parts = ActiveSupport::Duration.build(value).parts
    parts.collect {|key, value| "#{value} #{t(key)}" }.to_sentence
  end

  def camunda_time(value)
    if value.present?
      value.insert(-3, ":")
      Time.rfc3339(value)
    end
  end

  def plutus_accounts(account)
    account.remove("Plutus::")
  end
end
