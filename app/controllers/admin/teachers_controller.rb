class Admin::TeachersController < Admin::MainController
    
    def index
        @teachers=Teacher.all
    end

    def show
        @teacher=Teacher.find(params[:id])
    end

    def new
        @teacher=Teacher.new
    end
    def create
        @teacher=Teacher.new(teacher_params)
        @teacher.course_ids = selected_course_ids
        
        if @teacher.save    
            flash[:notice] = "Teacher was successfully Created."
            redirect_to admin_teachers_path
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @teacher=Teacher.find(params[:id])
    end

    def update
        @teacher=Teacher.find(params[:id])
        @teacher.assign_attributes(teacher_params)
        @teacher.course_ids = selected_course_ids

        if @teacher.save
            flash[:notice] = "Teacher was successfully Updated."
            redirect_to admin_teacher_path(@teacher)
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @teacher=Teacher.find(params[:id])
        @teacher.destroy
        flash[:notice] = "Teacher was successfully Delete."
        redirect_to admin_teachers_path, status: :see_other
    end

    private

    def teacher_params
        params.require(:teacher).permit(:name,:father_name,:address,:phone_number,:email,:password,:dob)
    end

    def selected_course_ids
        Array(params[:course_ids] || params.dig(:teacher, :course_ids)).reject(&:blank?)
    end
end
