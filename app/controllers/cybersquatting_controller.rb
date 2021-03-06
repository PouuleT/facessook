#encoding: utf-8
class CybersquattingController < ApplicationController
  respond_to :html, :json

  def index
    render :index, layout: false
  end

  def how_much
    @domain = params[:d] || 'facebook'
    @domain_price = params[:domain_price].try(:to_f) || 4.99

    # ß, à, á, â, ã, ä, å, æ, ç, è, é, ê, ë, ì, í
    # î, ï, ñ, ò, ó, ô, õ, ö, ù, ú, û, ü, ý, ÿ, œ
    squatting = {
      'a' => ['à', 'á', 'â', 'ã', 'ä', 'å', 'æ'],
      'b' => ['ß'],
      'c' => ['ç'],
      'e' => ['è', 'é', 'ê', 'ë', 'œ'],
      'i' => ['ì', 'í', 'î', 'ï'],
      'n' => ['ñ'],
      'o' => ['ò', 'ó', 'ô', 'õ', 'ö', 'œ'],
      'u' => ['ù', 'ú', 'û', 'ü'],
      'y' => ['ý', 'ÿ']
    }

    @domains = @domain.split(//).reduce(['']) do |ary, c|
      ary = ary.map do |partial_domain|
        squatting[c].try(:map){|sc| partial_domain + sc}.try(:<<, partial_domain + c) || partial_domain + c
      end
      ary.flatten
    end

    @price = @domain_price * (@domains.length - 1)
    r = {domains: @domains, price: @price}
    respond_with r.to_json
  end
end
