require 'spec_helper'

describe Jobs do
  it 'has a version number' do
    expect(Jobs::VERSION).not_to be nil
  end

  context 'class variables' do
    describe 'Jobs#order' do

      # Given you’re passed an empty string (no jobs), the result should be an empty sequence.
      it 'should pass example 1'

      # Given the following job structure:
      #   a =>
      # The result should be a sequence consisting of a single job a.
      it 'should pass example 2'

      # Given the following job structure:
      #   a =>
      #   b =>
      #   c =>
      # The result should be a sequence containing all three jobs abc in no significant order.
      it 'should pass example 3'

      # Given the following job structure:
      #   a =>
      #   b => c
      #   c =>
      # The result should be a sequence that positions c before b, containing all three jobs abc.
      it 'should pass example 4'

      # Given the following job structure:
      #   a =>
      #   b => c
      #   c => f
      #   d => a
      #   e => b
      #   f =>
      # The result should be a sequence that positions f before c, c before b, b before e and a before d containing
      # all six jobs abcdef.
      it 'should pass example 5'

      # Given the following job structure:
      #   a =>
      #   b =>
      #   c => c
      # The result should be an error stating that jobs can’t depend on themselves.
      it 'should pass example 6'

      # Given the following job structure:
      #   a =>
      #   b => c
      #   c => f
      #   d => a
      #   e =>
      #   f => b
      # The result should be an error stating that jobs can’t have circular dependencies.
      it 'should pass example 7'

    end
  end

end
