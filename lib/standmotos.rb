require "standmotos/version"
require "f1sales_custom/parser"
require "f1sales_custom/source"
require "f1sales_helpers"

module Standmotos
  class Error < StandardError; end
  class F1SalesCustom::Email::Source
    def self.all
      [
        {
          email_id: 'website',
          name: 'Website'
        },
      ]
    end
  end
  class F1SalesCustom::Email::Parser
    def parse
      parsed_email = @email.body.colons_to_hash(/(Telefone|Whatsapp|Nome|Observação|Subtotal|Mensagem|Itens|Email|CPF).*?:/, false) unless parsed_email

      {
        source: {
          name: F1SalesCustom::Email::Source.all[0][:name],
        },
        customer: {
          name: parsed_email['nome'],
          phone: parsed_email['telefone'],
          email: parsed_email['email'],
        },
        product: (parsed_email['itens'] || '').split(' - ')[0..1].join(' - '),
        message: parsed_email['observao'],
        description: "",
      }
    end
  end
end
