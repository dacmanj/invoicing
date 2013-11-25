require "spec_helper"

describe EmailRecordsController do
  describe "routing" do

    it "routes to #index" do
      get("/email_records").should route_to("email_records#index")
    end

    it "routes to #new" do
      get("/email_records/new").should route_to("email_records#new")
    end

    it "routes to #show" do
      get("/email_records/1").should route_to("email_records#show", :id => "1")
    end

    it "routes to #edit" do
      get("/email_records/1/edit").should route_to("email_records#edit", :id => "1")
    end

    it "routes to #create" do
      post("/email_records").should route_to("email_records#create")
    end

    it "routes to #update" do
      put("/email_records/1").should route_to("email_records#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/email_records/1").should route_to("email_records#destroy", :id => "1")
    end

  end
end
