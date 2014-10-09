require 'rails_helper'

describe WallPolicy do

  describe 'visibility' do

    it 'should include my own wall' do
    end

    context 'as an HQ employee' do
      it 'should include my department wall' do
      end

      it 'should NOT include other department walls' do
      end

      it 'should include all area and project walls' do
      end
    end

    context 'as a field employee' do
      it 'should include all area walls in my person_area(s)' do
      end

      it 'should include all ancestors for my area' do
      end
    end

    context 'as somebody with all_walls_permission' do
      it 'should include ALL walls' do
      end
    end
  end
end
