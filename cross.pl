#!/usr/bin/perl -w
#
#  Game noughts and crosses
#
use strict;
use warnings;

use Wx;
use Data::Dumper;

my @board = ([10, 10, 10,],[10, 10, 10,],[10, 10, 10,]);

my @playere_move = ();

&current_board(@board);

my %define_bw = ( 0=>'h', 1=>'c' );
my %start = each(%define_bw);
my ($bw) = keys %start;
foreach (1..9)
{
    $bw = ($bw == 0) ? 1 : 0;
    push( @playere_move, &make_move(\@playere_move, \@board, $bw));
    #print Dumper(\@playere_move)."\n\n";
    @board = update_board(\@board, $playere_move[-1], $bw);
    my $score = count_score(\@board);
    &current_board(@board);
    exit if ( $score != 10 );
}

sub count_score
{
    my $b = shift;
    my @board = @{$b};
    my $count_a = 0;
    my $count_b = 0;
    my $who = 10;
    foreach my $index ( 0, 1 )
    {
        foreach my $row ( 0, 1, 2 )
        {     
            if (    $board[$row][0] eq $board[$row][1] && 
                    $board[$row][1] eq $board[$row][2] &&
                    $board[$row][0] eq $index )
            {
                $who = $index;
                print "Player: $who fin\n";
                return &current_board(@board);
            } 
        }
    }

    my $col;
    foreach my $index ( 0, 1 )
    {
        foreach my $col ( 0, 1, 2 )
        {
            if (    $board[0][$col] eq $board[1][$col] &&
                    $board[1][$col] eq $board[2][$col] &&
                    $board[0][$col] eq $index )
            {
                $who = $index;
                print "Player: $who fin \n";
            }
        }
    }
    foreach my $index ( 0, 1 )
    {
        if (    $board[0][0] eq $board[1][1] &&
                $board[1][1] eq $board[2][2] &&
                $board[2][2] eq $index )
        {
            $who = $index;
            print "Player: $who fin \n";
        }
    }

    foreach my $index ( 0, 1 )
    {
        if (    $board[0][2] eq $board[1][1] &&
                $board[1][1] eq $board[2][0] &&
                $board[2][0] eq $index )
        {
            $who = $index;
            print "!!! Player: $who fin!!! \n\n";
        }
    }

 
    return $who;
}

sub update_board 
{
    my ( $b, $move, $player ) = @_;
    my @board = @{$b};
    my ($x, $y) = &convert($move);
    $board[$x][$y] = $player;
    return (@board);     
}

sub current_board 
{
    my @board = @_;
    foreach my $in ( @board ){
        if ( ref($in) eq 'ARRAY' ){
            my @array = @{$in};
            foreach my $value ( @array ){
                print "\t".($value = ($value == 10 ) ? "-" : $value);
            }
        }
        print "\n";
    }
}

sub make_move
{
    my ( $player, $board, $bw ) = @_;
    my $other;
    $other = ( $bw == 0 ) ? 1 : 0;
    my $player_type = $define_bw{$bw};
    my @player = @{$player};
    my @board = @{$board};

    print "Make your move (numbers 0-8):" if ( $player_type eq 'h' );
    my ($x, $y, $move);
    do
    {
        if ( $player_type eq 'h' ) {
            $move = <STDIN>;
            chomp($move);
        } else {
            $move = &robot();    
        }
        ($x, $y) = &convert($move);
        print "You have made your choise, its: $move \n";
            #print "Going to update board...\n";
        # update board
        if ( $board[$x][$y] == 10 ){
            $board[$x][$y] = $bw;
            print "Going to update board...\n";
            return $move;
        } else {
            print "This position occupied. Try again: \n";   
        }
    } while ( 1 );
    push(@player, \($x, $y));
    return $move;
}

sub convert
{
    my $num = shift;
    my $x = int($num/3);
    my $y = $num - (3*$x);
    return ($x, $y);   
}

sub robot
{
    my $random = int(rand(8));
    return ($random);
}
