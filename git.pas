Uses Crt, Dos ;
		Const
				MaxX = 319;
				MaxY = 199;
			Var
					V : Array [0..MaxX, 0..MaxY] Of Byte Absolute
		$A000:0;

				Procedure PutPixel (X,Y: Integer; Color: Byte) ;
			Assembler;
				Asm
						Mov		Ax, 0A000h
						Mov		Es, Ax			{Es = $A000}
						Mov		Ax, Y
						Shl		Ax, 6
						Mov		Bx, Ax			{Bx = Y * 64}
						Shl		Ax, 1
						Shl		Ax, 1			{Ax = Y * 256}
						Add		Bx, Ax			{Bx = Y * 320}
						Add		Bx, x			{Bx = Y * 320 + X}
						Mov		Al, Color		{Load Color}
						Mov		Es : [Bx], Al {Set point}
					End;

					Procedure DrawEllipse (MX, MY, A, B, Color : Integer);
						Var
								X, MX1, MX2, MY1, MY2		: Integer;
								Aq, Bq, Dx, Dy, R, Rx, Ry	: LongInt;

						Begin
						PutPixel (MX + A, MY, Color);
						PutPixel (MX - A, MY, Color);
						MX1 := MX - A;
						MY1 := MY;
						MX2 := MX + A;
						MY2 := MY;
						Aq := LongInt (A) * A;		{Calc Sqr}
						Bq := LongInt (B) * B;
						Dx := Aq Shl 1;				{Dx := 2 * A * A}
						Dy := Bq Shl 1;				{Dy := 2 * B * B}
						R := A * Bq;				{R := A * B * B}
						Rx := R Shl 1;				{Rx := 2 * A * B * B}
						Ry := 0;					{Y = 0}
						X := A;

						While X > 0 Do
						Begin
								If R > 0 Then
								Begin
										Inc (MY1);		{Y + 1}
										Dec (MY2);	
										Inc (Ry, Dx); 	{Ry = Dx * Y}
										Dec (R, Ry);	{R = R - Dx + Y}
								End;
								PutPixel (MX1, MY1, Color);
								PutPixel (MX1, MY2, Color);
								PutPixel (MX2, MY1, Color);
								PutPixel (MX2, MY2, Color);
						End;
				End;


				Var
						A, B : Integer;
						R : Registers;

				Begin
						R.Ax := $13;
						Intr ($10, R);
						Repeat
								A := 1 + Random(100);
								B := 1 + Random(99);
										DrawEllipse (A + Random(MaxX - 2 * A), B + Random (MaxY - 2 * B), A, B, 1 + Random(255));
													Delay(1000);
												Unit Keypressed;
												Text Mode(3);
											End.




