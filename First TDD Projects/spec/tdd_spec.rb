require "rspec"
require "tdd"

describe "my_uniq" do
  let(:array) { [1, 3, 4, 1, 3, 7] }
  let(:uniqued_array) { my_uniq(array.dup) }

  it "removes duplicates" do
    array.each do |item|
      expect(uniqued_array.count(item)).to eq(1)
    end
  end

  it "only contains items from original array" do
    uniqued_array.each do |item|
      expect(array).to include(item)
    end
  end

  it "does not modify original array" do
    expect {
      my_uniq(array)
    }.to_not change{array}
  end
end

describe "two_sum" do
    let(:array) {[-1, 0, 2, -2, 1]}
    it "finds all pairs" do 
        expect(two_sum(array)).to eq([[0,4],[2,3]])
    end
end

describe "my_transpose" do
    let (:matrix) {[
      [0,1,2],
      [3,4,5],
      [6,7,8]
    ]}
  it "transposes a matrix" do
    expect(my_transpose(matrix)).to eq([
      [0,3,6],
      [1,4,7],
      [2,5,8]
    ])
  end
end

describe "pick_stocks" do
  it "finds the best pair" do 
    expect(pick_stocks([3,2,5,0,6])). to eq([3,4])
  end

  it "does not buy stocks in a crash" do 
    expect(pick_stocks([5,4,3,2,1])). to be_nil
  end
end

describe TowersOfHanoi do
    subject (:test_game) {TowersOfHanoi.new}

    describe "#move" do
      it "allows moving to a blank space" do
        expect {test_game.move(0,1)}.not_to raise_error
      end

      it "allows moving onto a larger disk" do
        test_game.move(0,2)
        test_game.move(0,1)
        expect {test_game.move(2,1)}.not_to raise_error
      end

      it "doesnt allow moving from empty stack" do
        expect {test_game.move(1,2)}.to raise_error("can't move from empty stack")
      end

      it "doesn't allow a larger onto a smaller" do
        test_game.move(0,1)
        expect {test_game.move(0,1)}.to raise_error("can't move a large onto a small")
      end
    end

    describe "#won" do 
      it "isn't immediately won" do
        expect(test_game).not_to be_won
      end

      it "is won when all disks are moved to tower 1" do
        # Perform the moves to move the game into winning position
        test_game.move(0, 1)
        test_game.move(0, 2)
        test_game.move(1, 2)
        test_game.move(0, 1)
        test_game.move(2, 0)
        test_game.move(2, 1)
        test_game.move(0, 1)

        expect(test_game).to be_won
      end

      it "is won when all disks are moved to tower 2" do
        # Perform the moves to move the game into winning position
        test_game.move(0, 2)
        test_game.move(0, 1)
        test_game.move(2, 1)
        test_game.move(0, 2)
        test_game.move(1, 0)
        test_game.move(1, 2)
        test_game.move(0, 2)

        expect(test_game).to be_won
      end
    end
      

end