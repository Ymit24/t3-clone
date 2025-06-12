class ChatThreadsController < ApplicationController
    before_action :set_chat_thread, only: [:show, :edit, :update, :destroy]
    before_action :set_chat_threads, only: [:index, :show, :new, :edit]
    layout 'chat', only: [:index, :show, :new, :edit]

    def index
        redirect_to new_chat_thread_path
    end

    def show
        respond_to do |format|
            format.html
            format.turbo_stream
        end
    end

    def new
        @chat_thread = ChatThread.new(user: current_user)
        respond_to do |format|
            format.html
            format.turbo_stream
        end
    end

    def edit
        respond_to do |format|
            format.html
            format.turbo_stream
        end
    end

    def update
        respond_to do |format|
            if @chat_thread.update(chat_thread_params)
                format.html { redirect_to @chat_thread, notice: 'Chat thread was successfully updated.' }
                format.turbo_stream { 
                    render turbo_stream: [
                        turbo_stream.replace(helpers.dom_id(@chat_thread), partial: "chat_threads/thread_list", locals: { chat_thread: @chat_thread }),
                        turbo_stream.update("chat_content", template: "chat_threads/show", locals: { chat_thread: @chat_thread })
                    ]
                }
            else
                format.html { render :edit, status: :unprocessable_entity }
                format.turbo_stream { 
                    render turbo_stream: turbo_stream.update("chat_content", 
                        partial: "chat_threads/form", 
                        locals: { chat_thread: @chat_thread }
                    )
                }
            end
        end
    end

    def create
        @chat_thread = current_user.chat_threads.new(chat_thread_params)

        respond_to do |format|
            if @chat_thread.save
                format.html { redirect_to @chat_thread, notice: 'Chat thread was successfully created.' }
                format.turbo_stream { 
                    render turbo_stream: [
                        turbo_stream.append("chat_threads", partial: "chat_threads/thread_list", locals: { chat_thread: @chat_thread }),
                        turbo_stream.update("chat_content", template: "chat_threads/show", locals: { chat_thread: @chat_thread })
                    ]
                }
            else
                format.html { render :new, status: :unprocessable_entity }
                format.turbo_stream { 
                    render turbo_stream: turbo_stream.update("chat_content", 
                        partial: "chat_threads/form", 
                        locals: { chat_thread: @chat_thread }
                    )
                }
            end
        end
    end

    def destroy
        @chat_thread.destroy
        respond_to do |format|
            format.html { redirect_to chat_threads_url, notice: 'Chat thread was successfully destroyed.' }
            format.turbo_stream { 
                render turbo_stream: [
                    turbo_stream.remove(helpers.dom_id(@chat_thread)),
                    turbo_stream.update("chat_content", template: "chat_threads/index")
                ]
            }
        end
    end

    private

    def set_chat_thread
        @chat_thread = current_user.chat_threads.find(params[:id])
    end

    def set_chat_threads
        @chat_threads = current_user.chat_threads
    end

    def chat_thread_params
        params.require(:chat_thread).permit(:title)
    end
end
