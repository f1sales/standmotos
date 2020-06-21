require 'ostruct'
require "f1sales_custom/parser"
require "f1sales_custom/source"

RSpec.describe F1SalesCustom::Email::Parser do

  context 'when is from a website' do
    let(:email){
      email = OpenStruct.new
      email.to = [email: 'website@standmotos.f1sales.org'],
      email.subject = 'Formulário de orçamento',
      email.body = "SOLICITAÇÃO DE ORÇAMENTO PARA GABRIEL FORTUNATO TEIXEIRA DE AGUIAR\n\nNome: GABRIEL FORTUNATO TEIXEIRA DE AGUIAR\n\nTelefone: 21984496373\n\nWhatsapp: 21984496373\n\nEmail: gabrielfortunato@gmail.com\n\nObservação: queria fazer uam simulação de financiamento\n\nItens:\n\nFVS2208 - Triumph Street Scrambler 900 ABS (1) - R$ 30,50 - Subtotal:\n30.500,00"

      email
    }

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains lead website a source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[0][:name])
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('GABRIEL FORTUNATO TEIXEIRA DE AGUIAR')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('gabrielfortunato@gmail.com')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('21984496373')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('queria fazer uam simulação de financiamento')
    end

    it 'contains product' do
      expect(parsed_email[:product]).to eq('FVS2208 - Triumph Street Scrambler 900 ABS (1)')
    end
  end
end
