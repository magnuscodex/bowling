class ScoreCardController < ApplicationController

  def new
    scores = [nil] * 10
    @form_vals = []
    for i in (0...10)
      @form_vals << [nil,nil]
    end

    # Awkward, there's probably a better way to do this.
    @form_vals[0][0] = params[:Frame1_bowl1].to_i
    @form_vals[0][1] = params[:Frame1_bowl2].to_i
    @form_vals[1][0] = params[:Frame2_bowl1].to_i
    @form_vals[1][1] = params[:Frame2_bowl2].to_i
    @form_vals[2][0] = params[:Frame3_bowl1].to_i
    @form_vals[2][1] = params[:Frame3_bowl2].to_i
    @form_vals[3][0] = params[:Frame4_bowl1].to_i
    @form_vals[3][1] = params[:Frame4_bowl2].to_i
    @form_vals[4][0] = params[:Frame5_bowl1].to_i
    @form_vals[4][1] = params[:Frame5_bowl2].to_i
    @form_vals[5][0] = params[:Frame6_bowl1].to_i
    @form_vals[5][1] = params[:Frame6_bowl2].to_i
    @form_vals[6][0] = params[:Frame7_bowl1].to_i
    @form_vals[6][1] = params[:Frame7_bowl2].to_i
    @form_vals[7][0] = params[:Frame8_bowl1].to_i
    @form_vals[7][1] = params[:Frame8_bowl2].to_i
    @form_vals[8][0] = params[:Frame9_bowl1].to_i
    @form_vals[8][1] = params[:Frame9_bowl2].to_i
    @form_vals[9][0] = params[:Frame10_bowl1].to_i
    @form_vals[9][1] = params[:Frame10_bowl2].to_i
    @form_vals[9][2] = params[:Frame10_bowl3].to_i #Potential extra ball

    #Handle normal error cases
    @error_val = [nil]*10
    first_error = nil
    for i in (0...9)
      if @form_vals[i][0].nil? or @form_vals[i][1].nil?
        next
      end
      v1 = @form_vals[i][0]
      v2 = @form_vals[i][1]
      val = v1 + v2
      if val > 10 or v1 < 0 or v2 < 0
        @error_val[i] = "has-error" 
        if @first_error.nil?
          @first_error = i
        end
      end
    end

    #Handle last frame error case
    v1 = @form_vals[9][0]
    v2 = @form_vals[9][1]
    v3 = @form_vals[9][2]
    if v1 > 10 or v2 > 10 or v3 > 10 or v1 < 0 or v2 < 0 or v3 < 0 or (v1 + v2 == 10 and v3 != 0)
      @first_error = 9 if @first_error.nil?
      @error_val[9] = "has-error"
    end

    score = [nil]*10
    for i in (0...10)
      if @first_error == i
        break
      end
      score[i] = @form_vals[i][0] + @form_vals[i][1]
      if @form_vals[i][0] == 10
        if i == 9
          score[i] += @form_vals[i][2]
        else
          score[i] += @form_vals[i+1][0]
          if @form_vals[i+1][0] == 10
            if i == 8
              score[i] += @form_vals[i+1][1]
            else
              score[i] += @form_vals[i+2][0]
            end
          else
            score[i] += @form_vals[i+1][1]
          end
        end
      elsif score[i] == 10
        if i == 9
          score[i] += @form_vals[i][1]
        else
          score[i] += @form_vals[i+1][0]
        end
      end
    end

    @scores = []
    total = 0
    for s in score
      total += s
      @scores << total
    end

    render "score_card/new"
  end

end
