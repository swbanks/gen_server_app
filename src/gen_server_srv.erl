%%% -------------------------------------------------------------------
%%% Author  : sbanks
%%% Description :
%%%
%%% Created : Jun 27, 2013
%%% -------------------------------------------------------------------
-module(gen_server_srv).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% External exports
-export([stop/0, start_link/0, remote_append_two_strings_and_hello_world/3, append_two_strings_and_hello_world/2, fizz_buzz/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%-record(state, {}).

%% ====================================================================
%% External functions
%% ====================================================================
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:cast(?MODULE, stop).

remote_append_two_strings_and_hello_world(Node, StringOne, StringTwo) ->
	gen_server:call({?MODULE, Node}, {append_two_strings, StringOne, StringTwo}).

append_two_strings_and_hello_world(StringOne, StringTwo) ->
	gen_server:call(?MODULE, {append_two_strings, StringOne, StringTwo}).
	
fizz_buzz(Number) ->
	if 
		(Number rem 3 == 0) and (Number rem 5 == 0) ->
			"fizz buzz";
		Number rem 5 == 0 ->
			"buzz";
		Number rem 3 == 0 ->
			"fizz";
		true ->
			"no match"
	end.
  
%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
    {ok, 0}.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_call({append_two_strings, StringOne, StringTwo}, _From, State) ->
    
	Reply = StringOne++StringTwo++" hello woooooorld!",
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State+1}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast(stop, State) ->
	{stop, normal, State};
handle_cast(_Msg, State) ->
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info({some_func, _From, _Param1, _Param2} = Info, State) ->
	% some_func(From, Param1, Param2),
	error_logger:info_msg("handle_info ~p~n", [Info]),
	{noreply, State};
handle_info(Info, State) ->
	error_logger:info_msg("handle_info ~p~n", [Info]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, State) ->
	error_logger:info_msg("I was called ~p times ~n", [State]),
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------

