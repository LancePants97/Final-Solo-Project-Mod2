require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe "validations" do
    describe "relationships" do
      it { should belong_to :merchant }
    end
  end
end