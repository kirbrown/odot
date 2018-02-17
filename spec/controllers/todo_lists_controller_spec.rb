require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

# rubocop:disable Metrics/BlockLength
RSpec.describe TodoListsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # TodoList. As you add validations to TodoList, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      title: 'My Title'
    }
  end

  let(:invalid_attributes) do
    {
      title: ''
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TodoListsController. Be sure to keep this updated too.
  let(:valid_session) do
    {
      title: 'My Title'
    }
  end

  let!(:user) { create(:user) }
  before { sign_in(user) }

  describe 'GET #index' do
    context 'logged in' do
      it 'assigns all todo_lists as @todo_lists' do
        todo_list = user.todo_lists.create! valid_attributes
        get :index, params: { user: :valid_session }
        expect(assigns(:todo_lists)).to eq([todo_list])
        expect(assigns(:todo_lists).map(&:user)).to eq([user])
      end

      it "does not load other user's todo lists" do
        other_todo_list = TodoList.create!(valid_attributes.merge(user_id: create(:user).id))
        get :index, params: { user: :valid_session }
        expect(assigns(:todo_lists)).to_not include(other_todo_list)
      end
    end
  end

  describe 'GET #new' do
    it 'assigns a new todo_list as @todo_list for the logged in user' do
      get :new, params: { user: :valid_session }
      expect(assigns(:todo_list)).to be_a_new(TodoList)
      expect(assigns(:todo_list).user).to eq(user)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested todo_list as @todo_list' do
      todo_list = user.todo_lists.create! valid_attributes
      get :edit, params: { id: todo_list.to_param, user: valid_session }
      expect(assigns(:todo_list)).to eq(todo_list)
      expect(assigns(:todo_list).user).to eq(user)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new TodoList' do
        expect do
          post :create, params: { todo_list: valid_attributes, user: valid_session }
        end.to change(TodoList, :count).by(1)
      end

      it 'assigns a newly created todo_list as @todo_list' do
        post :create, params: { todo_list: valid_attributes }
        expect(assigns(:todo_list)).to be_a(TodoList)
        expect(assigns(:todo_list)).to be_persisted
      end

      it 'redirects to the created todo list items' do
        post :create, params: { todo_list: valid_attributes }
        expect(response).to redirect_to(todo_list_todo_items_path(TodoList.last))
      end

      it 'creates a todo list for the current user' do
        post :create, params: { todo_list: valid_attributes }
        todo_list = TodoList.last
        expect(todo_list.user).to eq(user)
      end

      it 'does not allow users to create todo_lists for other users' do
        other_user = create(:user)
        post :create, params: { todo_list: valid_attributes.merge(user_id: other_user.id) }
        todo_list = TodoList.last
        expect(todo_list.user).to eq(user)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved todo_list as @todo_list' do
        post :create, params: { todo_list: invalid_attributes }
        expect(assigns(:todo_list)).to be_a_new(TodoList)
      end

      it "re-renders the 'new' template" do
        post :create, params: { todo_list: invalid_attributes }
        expect(response).to render_template('new')
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved todo_list as @todo_list' do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(TodoList).to receive(:save).and_return(false)
        post :create, params: { todo_list: { title: 'invalid value' } }
        expect(assigns(:todo_list)).to be_a_new(TodoList)
        expect(assigns(:todo_list).user).to eq(user)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(TodoList).to receive(:save).and_return(false)
        post :create, params: { todo_list: { title: 'invalid value' } }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    describe 'with valid params' do
      it 'updates the requested todo_list' do
        todo_list = user.todo_lists.create! valid_attributes
        # Assuming there are no other todo_lists in the database, this
        # specifies that the TodoList created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        allow(TodoList).to receive(:update).with(title: 'MyString')
        put :update, params: { id: todo_list.to_param, todo_list: { title: 'MyString' } }
      end

      it 'assigns the requested todo_list as @todo_list' do
        todo_list = user.todo_lists.create! valid_attributes
        put :update, params: { id: todo_list.to_param, todo_list: valid_attributes }
        expect(assigns(:todo_list)).to eq(todo_list)
        expect(assigns(:todo_list).user).to eq(user)
      end

      it 'redirects to the todo list items' do
        todo_list = user.todo_lists.create! valid_attributes
        put :update, params: { id: todo_list.to_param, todo_list: valid_attributes }
        expect(response).to redirect_to(todo_list_todo_items_path(todo_list))
      end
    end

    describe 'with invalid params' do
      it 'assigns the todo_list as @todo_list' do
        todo_list = user.todo_lists.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(TodoList).to receive(:save).and_return(false)
        put :update, params: { id: todo_list.to_param, todo_list: { title: 'invalid value' } }
        expect(assigns(:todo_list)).to eq(todo_list)
      end

      it "re-renders the 'edit' template" do
        todo_list = user.todo_lists.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(TodoList).to receive(:save).and_return(false)
        put :update, params: { id: todo_list.to_param, todo_list: { title: 'invalid value' } }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested todo_list' do
      todo_list = user.todo_lists.create! valid_attributes
      expect do
        delete :destroy, params: { id: todo_list.to_param }
      end.to change(user.todo_lists, :count).by(-1)
    end

    it 'redirects to the todo_lists list' do
      todo_list = user.todo_lists.create! valid_attributes
      delete :destroy, params: { id: todo_list.to_param }
      expect(response).to redirect_to(todo_lists_url)
    end
  end
end
# rubocop:enable Metrics/BlockLength
