require 'spec_helper'

describe SalesEngine::Merchant do
  context "Searching" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        merchant_one = SalesEngine::Merchant.random
        merchant_two = SalesEngine::Merchant.random

        10.times do
          break if merchant_one.id != merchant_two.id
          merchant_two = SalesEngine::Merchant.random
        end

        merchant_one.id.should_not == merchant_two.id
      end
    end

    describe ".find_by_name" do
      it "can find a record" do
        merchant = SalesEngine::Merchant.find_by_name "Marvin Group"
        merchant.should_not be_nil
      end
    end

    describe ".find_by_all_name" do
      it "can find multiple records" do
        merchants = SalesEngine::Merchant.find_all_by_name "Williamson Group"
        merchants.should have(2).merchants
      end
    end
  end

  context "Relationships" do
    let(:merchant) { SalesEngine::Merchant.find_by_name "Kirlin, Jakubowski and Smitham" }

    describe "#items" do
      it "has 33 of them" do
        merchant.items.should have(33).items
      end
    end

    it "includes an 'Item Consequatur Odit'" do
      item = merchant.items.find {|i| i.name == 'Item Consequatur Odit' }
      item.should_not be_nil
    end

    describe "#invoices" do
      it "has 52 of them" do
        merchant.invoices.should have(43).invoices
      end

      it "has a shipped invoice for Block" do
        invoice = merchant.invoices.find {|i| i.customer.last_name == 'Block' }
        invoice.status.should == "shipped"
      end
    end
  end

  context "Business Intelligence" do
    describe ".revenue" do
      it "returns all revenue for a given date" do
        date = Date.parse "Tue, 20 Mar 2012"

        revenue = SalesEngine::Merchant.revenue(date)
        revenue.should == BigDecimal.new("2549722.91")
      end
    end

    describe ".most_revenue" do
      it "returns the top n revenue-earners" do
        most = SalesEngine::Merchant.most_revenue(3)
        most.first.name.should == "Dicki-Bednar"
        most.last.name.should  == "Okuneva, Prohaska and Rolfson"
      end
    end
  end

end