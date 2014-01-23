class ScoreCardController < ApplicationController

  # Score a scorecard.
  def new
    scores = [nil] * 10
    @form_vals = []
    for i in (0...10)
      @form_vals << [nil,nil]
    end

    # The values of the bowls from the different frames should be put into
    # the form_vals instance variale
    for i in (0..9)
      bowls = i == 9 ? 2 : 1
      for j in (0..bowls)
        @form_vals[i][j] = params["Frame#{i+1}_bowl#{j+1}".intern].to_i
      end
    end

    @error_val = find_errors(@form_vals)
    @first_error = @error_val.index("has-error")


    @scores = score_game(@form_vals, @first_error)

    render "score_card/new"
  end

  def find_errors(frames)

    #Handle normal error cases
    errors = [nil]*10
    for i in (0...9)
      if frames[i][0].nil? or frames[i][1].nil?
        next
      end
      v1 = frames[i][0]
      v2 = frames[i][1]
      val = v1 + v2
      if val > 10 or v1 < 0 or v2 < 0
        errors[i] = "has-error"
      end
    end

    #Handle last frame error case
    v1 = frames[9][0]
    v2 = frames[9][1]
    v3 = frames[9][2]
    if v1 > 10 or v2 > 10 or v3 > 10 or v1 < 0 or v2 < 0 or v3 < 0 or (v1 + v2 < 10 and v3 != 0) or (v1 != 10 and v1 + v2 > 10)
      errors[9] = "has-error"
    end

    return errors 
  end

  def score_game(frames, first_error)

    #Generate Frame scores
    score = [nil]*10
    for i in (0...10)
      #Don't score past input errors.
      if @first_error == i
        break
      end
      score[i] = frames[i][0] + frames[i][1]
      #If we had a strike
      if frames[i][0] == 10
        #The last two frames are scored differently since there is no
        #frame 11
        if i == 9
          score[i] += frames[i][2]
        else
          score[i] += frames[i+1][0]
          if frames[i+1][0] == 10
            #When scoring a strike for frame 9 if frame 10 was also a
            #strike then the second additional bowl comes from the first
            #additional bowl in frame 10
            if i == 8
              score[i] += frames[i+1][1]
            else
              score[i] += frames[i+2][0]
            end
          else
            score[i] += frames[i+1][1]
          end
        end
      #Scoring for a spare
      elsif score[i] == 10
        if i == 9
          score[i] += frames[i][1]
        else
          score[i] += frames[i+1][0]
        end
      end
    end

    #Running total up to a given frame
    scores = []
    total = 0
    for i in (0...10)
      if first_error == i
        break
      end
      total += score[i]
      scores << total
    end

    return scores
  end

end
