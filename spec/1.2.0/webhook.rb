require_relative '../spec_helper'

describe "1.2.0" do
  context "Webhook" do
    it "can create webhook" do
      @store[:client] = Finnhub::Client.new(key: @key, verbose: true)
      @store[:webhook] = @store[:client].webhook
    end

    it "can add a webhook" do
      @store[:webhook].create(body: {'event': 'earnings', 'symbol': 'AAPL'})
      expect(@store[:webhook].id).not_to be nil
    end

    it "can list webhooks" do
      webhooks = @store[:client].webhooks
      expect(webhooks[0].id).to eq @store[:webhook].id
    end

    it "can delete a webhook" do
      @store[:webhook].delete
      expect(@store[:webhook].id).to eq nil
    end
  end
end
